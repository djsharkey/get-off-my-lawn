class_name Item

extends RigidBody3D

@export var item_name: String = ""
@export var icon: Texture2D
@export var stack_limit: int = 1
@export var current_stack_count: int = 0
@export var item_weight: float = 0
@export var required_hold_duration: float = 0
var _original_parent: Node3D
var pickup_cooldown_duration: float = 2

@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	_original_parent = self.get_parent()
	interactable.interacted.connect(grab_item)


func _use_item() -> void:
	EventBus.item_used.emit()


func grab_item(body: Node3D):
	interactable.set_deferred("monitoring", false)
	if $CollisionShape3D:
		$CollisionShape3D.set_deferred("disabled", true)
	self.global_transform = body.global_transform
	self.reparent.call_deferred(body, true)
	self.freeze = true
	EventBus.item_grabbed.emit.call_deferred(self, body)


func drop_item(direction: Vector3):
	if _original_parent == null:
		return

	self.reparent.call_deferred(_original_parent)
	self.freeze = false
	self.apply_central_impulse(direction)
	interactable.set_deferred("monitoring", true)
	if $CollisionShape3D:
		$CollisionShape3D.set_deferred("disabled", false)
	EventBus.item_dropped.emit.call_deferred(self)
