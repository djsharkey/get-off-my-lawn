class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var rotation_speed: float = TAU * 2
var equipped_item: Item
var nearby_interactables: Array[Interactable] = []
var baseline_weight: float = 1.0
var item_weight = 0

@onready var player_model: Node3D = $Model

func _ready() -> void:
	EventBus.item_grabbed.connect(_on_item_grabbed)
	EventBus.item_used.connect(_on_item_used)
	EventBus.item_dropped.connect(_on_item_dropped)
	EventBus.interactable_entered.connect(_on_interactable_entered)
	EventBus.interactable_exited.connect(_on_interactable_exited)


func _physics_process(delta):
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

	if Input.is_action_just_pressed("grab_item"):
		var interactable: Interactable = get_current_interactable()

		if interactable != null:
			interactable.interact(self)

	if Input.is_action_just_pressed("debug_focus_oldman"):
		%CameraRig.focus_on(%OldMan)

	if Input.is_action_just_pressed("debug_focus_player"):
		%CameraRig.focus_on(%Player)

	if Input.is_action_just_pressed("complete_task"):
		%ProgressBar.value = fmod(%ProgressBar.value + 1, %ProgressBar.max_value + 1)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		player_model.rotation.y = rotate_toward(
			player_model.rotation.y,
			Vector2(direction.x, -direction.z).angle(),
			rotation_speed * delta
		)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_item_grabbed(item: Item, owner: Node3D):
	if equipped_item == null:
		equipped_item = item
	else:
		# TODO: Drop it first or put into inventory
		return

	equipped_item = item


func _on_item_used(item: Item, owner: Node3D):
	pass


func _on_item_dropped(item: Item):
	if equipped_item == null:
		# Nothing to drop
		return

	equipped_item = null


func _on_interactable_entered(interactable: Interactable) -> void:
	if nearby_interactables.has(interactable):
		print("Interactable already tracked")
		return
	
	# how do you check if the interactable is an item and your hands are already full to prevent the text from popping up?
	nearby_interactables.append(interactable)
	EventBus.interactable_selected.emit(get_current_interactable())


func _on_interactable_exited(interactable: Interactable) -> void:
	nearby_interactables.erase(interactable)
	EventBus.interactable_selected.emit(get_current_interactable())


func get_current_interactable() -> Interactable:
	if nearby_interactables.is_empty():
		return

	var current_interactable: Interactable = nearby_interactables.back()

	if  current_interactable != null:
		return current_interactable
	else:
		return
		
func get_raycast_visibility_mesh() -> MeshInstance3D:
	return $RaycastVisibilityMesh
