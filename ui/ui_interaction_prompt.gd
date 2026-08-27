extends CanvasLayer

func _ready() -> void:
	visible = false


func show_prompt(text: String) -> void:
	visible =true


func hide_prompt() -> void:
	visible = false
