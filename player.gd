extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var rotation_speed: float = TAU * 2
var equipped_item: Item
@onready var camera_rig: Node3D = $"../CameraRig"
@onready var player: CharacterBody3D = $"."
@onready var old_man: CharacterBody3D = $"../OldMan"

@onready var player_model: Node3D = $Model

func _ready() -> void:
	EventBus.item_grabbed.connect(_on_item_grabbed)
	EventBus.item_used.connect(_on_item_used)
	EventBus.item_dropped.connect(_on_item_dropped)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# TODO: Handle item drop
	if Input.is_action_just_pressed("drop_item"):
		if equipped_item == null:
			return

		equipped_item.drop_item()

	if Input.is_action_just_pressed("grab_item"):
		if equipped_item != null:
			return

		equipped_item.grab_item(self)

	if Input.is_action_just_pressed("debug_focus_oldman"):
		camera_rig.focus_on(old_man)

	if Input.is_action_just_pressed("debug_focus_player"):
		camera_rig.focus_on(player)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))#.normalized()
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

	item.grab_item(self)
	equipped_item = item


func _on_item_used(item: Item, owner: Node3D):
	pass


func _on_item_dropped(item: Item):
	if equipped_item == null:
		# Nothing to drop
		return

	# TODO: Apply an impulse and "toss" the item away from the player
	equipped_item = null
