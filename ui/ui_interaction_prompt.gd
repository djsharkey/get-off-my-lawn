extends CanvasLayer

@export var prompt_input_textures: Array[Texture2D] = []
var active_texture: Texture2D

func _ready() -> void:
	visible = false

	if active_texture == null:
		if !prompt_input_textures.is_empty():
			_update_prompt_texture(prompt_input_textures[0])
		else:
			print("Missing textures for input prompts!")

	EventBus.interactable_selected.connect(_on_interactable_selected)
	EventBus.item_grabbed.connect(_on_item_grabbed)

func _on_interactable_selected(interactable: Interactable) -> void:
	if interactable == null:
		_hide_prompt()
		return

	show_prompt(interactable.get_prompt_text())

func show_prompt(text: String) -> void:
	visible =true
	print("Show prompt text: %s" % text)


func _on_item_grabbed(item: Item, owner: Node3D):
	_hide_prompt()

func _hide_prompt() -> void:
	visible = false


func _update_prompt_texture(texture: Texture2D):
	active_texture = texture
