class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const DEFAULT_TURN_SPEED = TAU * 2
var current_speed = SPEED
@export var rotation_speed: float = TAU * 2
@export var whoosh_streams: Array[AudioStreamPlayer3D]
@export var footstep_streams: Array[AudioStreamPlayer3D]

var active_footstep_stream: AudioStreamPlayer3D
var equipped_item: Item
var nearby_interactables: Array[Interactable] = []
var baseline_weight: float = 1.0
var item_weight = 0
var item_stack_count = 0

@onready var player_model: Node3D = $Model

func _ready() -> void:
	EventBus.item_grabbed.connect(_on_item_grabbed)
	EventBus.item_used.connect(_on_item_used)
	EventBus.item_dropped.connect(_on_item_dropped)
	EventBus.interactable_entered.connect(_on_interactable_entered)
	EventBus.interactable_exited.connect(_on_interactable_exited)

	if active_footstep_stream == null && !footstep_streams.is_empty():
		active_footstep_stream = footstep_streams.pick_random()


func _physics_process(delta):
	# FIXME this should be tied to mower
	%GrassMask.stamp_world_position(global_position)
	if equipped_item != null:
		item_weight = equipped_item.item_weight
	else:
		item_weight = 0

	var total_weight = baseline_weight + item_weight
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	# shift input by current camera angle for "smoothness"
	var direction = (transform.basis * Vector3((input_dir.x / total_weight), 0, (input_dir.y / total_weight)))#.normalized()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# TODO: Handle item drop
	if Input.is_action_just_pressed("drop_item"):
		if equipped_item != null:
			if direction:
				var modified_dir: Vector3 = (direction + Vector3.UP * 0.5).normalized()
				equipped_item.drop_item(modified_dir * 10)
			else:
				equipped_item.drop_item(Vector3.UP * 8)

		if !whoosh_streams.is_empty() && equipped_item != null:
			var selected_sound = whoosh_streams.pick_random()
			print("selected_sound: %s" % selected_sound)
			selected_sound.play()

	if Input.is_action_just_pressed("grab_item"):
		var interactable: Interactable = get_current_interactable()

		if interactable != null:
			interactable.interact(self)

	if Input.is_action_just_pressed("debug_focus_oldman"):
		%CameraRig.focus_on(%OldMan)

	if Input.is_action_just_pressed("debug_focus_player"):
		%CameraRig.focus_on(%Player)

	if Input.is_action_just_pressed("complete_task"):
		EventBus.progress_increased.emit(Constants.Tasks.TOTAL, 1)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var mower = get_node_or_null("Mower")
	if direction:
		# Handle mesh rotations including weird unique mower logic
		if mower:
			mower.rotation.y = rotate_toward(
				mower.rotation.y,
				Vector2(direction.x, -direction.z).angle(),
				rotation_speed * delta
			)
			attach_to_point(mower.get_node("PlayerAttachPoint").global_position)
			player_model.rotation.y = mower.rotation.y
			
		else:
			player_model.rotation.y = rotate_toward(
				player_model.rotation.y,
				Vector2(direction.x, -direction.z).angle(),
				rotation_speed * delta
			)
		
		var forwardDirection = -player_model.global_transform.basis.x.normalized()
		velocity.x = forwardDirection.x * current_speed
		velocity.z = forwardDirection.z * current_speed
	else:
		if !mower:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	# Handle sounds
	if mower && !(mower.get_node("AudioStreamPlayer3D") as AudioStreamPlayer3D).playing:
		(mower.get_node("AudioStreamPlayer3D") as AudioStreamPlayer3D).play(0.0)
		if active_footstep_stream != null && active_footstep_stream.playing:
			active_footstep_stream.stop()
	elif velocity.x > 0 || velocity.z > 0:
		if  active_footstep_stream != null && !active_footstep_stream.playing:
			active_footstep_stream = footstep_streams.pick_random()
			print("active_footstep_stream: %s" % active_footstep_stream.name)
			active_footstep_stream.play()
	else:
		if active_footstep_stream != null && active_footstep_stream.playing:
			active_footstep_stream.stop()
			active_footstep_stream = footstep_streams.pick_random()
	move_and_slide()

func _on_item_grabbed(item: Item, owner: Node3D):
	if equipped_item == null:
		equipped_item = item
		item_stack_count += 1
	else:
		# TODO: Drop it first or put into inventory
		return

	equipped_item = item
	if item.name == "Mower":
		# TODO: Increase "interaction area size" on player
		current_speed *= 2.0
		rotation_speed /= 4.0
		


func _on_item_used(item: Item, owner: Node3D):
	pass


func _on_item_dropped(item: Item):
	if equipped_item == null:
		# Nothing to drop
		return
	
	current_speed = SPEED
	rotation_speed = DEFAULT_TURN_SPEED
	reset_attachment()
	equipped_item = null
	item_stack_count = 0


func _on_interactable_entered(interactable: Interactable) -> void:
	if nearby_interactables.has(interactable):
		print("Interactable already tracked")
		return

	# how do you check if the interactable is an item and your hands are already full to prevent the text from popping up?
	print("Interactable is ItemType: %s" % interactable.item_type)
	#if !check_if_can_interact(interactable):
		#return
	nearby_interactables.append(interactable)
	EventBus.interactable_selected.emit(get_current_interactable(), self)


func check_if_can_interact(interactable: Interactable) -> bool:
	if equipped_item != null:
		if equipped_item.item_type == Constants.ItemTypes.TOOL:
			if interactable.item_type == Constants.ItemTypes.TOOL:
				return false
			elif interactable.item_type == Constants.ItemTypes.BIN:
				return false
			elif interactable.item_type == Constants.ItemTypes.TWIG:
				return false
			elif interactable.item_type == Constants.ItemTypes.FLOWER:
				return false
			elif interactable.item_type == Constants.ItemTypes.WEED:
				return false
		elif equipped_item.item_type != Constants.ItemTypes.TOOL:
			if equipped_item.item_type != interactable.item_type:
				return false
			else:
				if item_stack_count <= equipped_item.stack_limit:
					return false
	else:
		if interactable.item_type == Constants.ItemTypes.BIN:
			return false

	return true


func _on_interactable_exited(interactable: Interactable) -> void:
	nearby_interactables.erase(interactable)
	EventBus.interactable_unselected.emit(get_current_interactable())


func get_current_interactable() -> Interactable:
	if nearby_interactables.is_empty():
		return

	var current_interactable: Interactable = nearby_interactables.back()

	if  current_interactable != null:
		return current_interactable
	else:
		return

# Just visually moves player mesh to attach point
func attach_to_point(globalAttachPosition):
	player_model.position = to_local(globalAttachPosition)
	
func reset_attachment():
	player_model.position = Vector3.ZERO

func get_raycast_visibility_mesh() -> MeshInstance3D:
	return $RaycastVisibilityMesh
