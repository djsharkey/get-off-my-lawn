extends CanvasLayer

@export var prompt_input_textures: Array[Texture2D] = []
var active_texture: Texture2D

func _ready() -> void:
	visible = false

	if active_texture == null:
		if !prompt_input_textures.is_empty():
			_update_prompt_texture(prompt_input_textures[0])
			return
		else:
			print("Missing textures for input prompts!")

	EventBus.player_detected.connect(_on_player_detected)

func _on_player_detected() -> void:
	show_prompt("USE")

func show_prompt(text: String) -> void:
	visible =true
	print("show prompt")


func hide_prompt() -> void:
	visible = false


func _update_prompt_texture(texture: Texture2D):
	active_texture = texture
