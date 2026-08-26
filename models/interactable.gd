class_name Interactable
extends Area3D

@export var prompt_text: String = "Action"

signal interacted(interactee: Node3D)

func get_text() -> String:
	return prompt_text
	
	
func interact(interactee: Node3D) -> void:
	interacted.emit(interactee)
