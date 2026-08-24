class_name Item

extends Node

signal item_used

@export var item_name: String = ""
@export var icon: Texture2D
@export var stackable: bool = false
@export var stack_limit: int
@export var current_stack_count: int = 0
@export var item_weight: float = 0


func _use_item() -> void:
	item_used.emit()
