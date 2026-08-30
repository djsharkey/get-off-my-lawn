class_name Item

extends RigidBody3D

@export var item_name: String = ""
@export var icon: Texture2D
@export var stack_limit: int = 1
@export var current_stack_count: int = 0
@export var item_weight: float = 0
@export var required_hold_duration: float = 0
var item_type: Constants.ItemTypes
var _original_parent: Node3D
var pickup_cooldown_duration: float = 2

@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	_original_parent = self.get_parent()
	interactable.interacted.connect(grab_item)
	if item_type == null:
		print("No ItemType provided!")
		return
	interactable.item_type = item_type
	interactable.interactable_object_id = get_instance_id()


func _use_item() -> void:
	EventBus.item_used.emit()


func grab_item(body: Node3D):
	var player: Player = body
	if player.equipped_item != null:
		print("You cannot grab me!! You're hands are full!")
		return
	interactable.set_deferred("monitoring", false)
	for child in get_children():
		if child is CollisionShape3D:
			child.set_deferred("disabled", true)
	self.freeze = true
	self.reparent.call_deferred(player, true)
	await get_tree().process_frame
	self.global_transform = player.global_transform
	var playerAttachmentPoint = get_node_or_null("PlayerAttachPoint")
	if playerAttachmentPoint:
		player.call_deferred("attach_to_point", playerAttachmentPoint.global_position)
	EventBus.item_grabbed.emit.call_deferred(self, player)
	


func drop_item(direction: Vector3):
	var playerAttachmentPoint = get_node_or_null("PlayerAttachPoint")
	if playerAttachmentPoint:
		get_parent().reset_attachment()
	if _original_parent == null:
		return

	self.reparent.call_deferred(_original_parent)
	self.freeze = false
	self.apply_central_impulse(direction)
	interactable.set_deferred("monitoring", true)
	for child in get_children():
		if child is CollisionShape3D:
			child.set_deferred("disabled", false)
	EventBus.item_dropped.emit.call_deferred(self)
