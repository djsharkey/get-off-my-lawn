class_name Interactable
extends Area3D

@export var prompt_text: String = "Grab"

#var iteractable_object = null

signal interacted(interactee: Node3D)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.name != "Player":
		return

	EventBus.interactable_entered.emit(self)


func _on_body_exited(body: Node3D) -> void:
	if body.name != "Player":
		return

	EventBus.interactable_exited.emit(self)


func get_prompt_text() -> String:
	return prompt_text


func interact(interactee: Node3D) -> void:
	interacted.emit(interactee)
