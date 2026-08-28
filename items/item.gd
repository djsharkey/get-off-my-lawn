class_name Item

extends Area3D

@export var item_name: String = ""
@export var icon: Texture2D
@export var stack_limit: int = 1
@export var current_stack_count: int = 0
@export var item_weight: float = 0
@export var required_hold_duration: float = 0
var _original_parent: Node3D
var player_near: bool = false
var pickup_cooldown_duration: float = 2

@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	_original_parent = self.get_parent()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) ->  void:
	if body.name != "Player":
		return

	player_near = true
	grab_item(body)
	EventBus.player_detected.emit()


func _on_body_exited(body: Node3D) ->  void:
	if body.name == "Player":
		player_near = false


func _use_item() -> void:
	EventBus.item_used.emit()


func grab_item(body: Node3D):
	if !player_near:
		print("Player out of range for pickup")
		self.set_deferred("monitoring", true)
		return

	# TODO: I would really like type safety on these deferred calls
	set_deferred("monitoring", false)
	self.global_transform = body.global_transform
	self.reparent.call_deferred(body, true)
	EventBus.item_grabbed.emit.call_deferred(self, body)


func drop_item():
	# TODO: Better handling for this
	if _original_parent == null:
		return

	self.reparent.call_deferred(_original_parent)
	set_deferred("monitoring", true)
	set_deferred("player_near", false)

	EventBus.item_dropped.emit.call_deferred(self)
