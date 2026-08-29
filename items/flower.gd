class_name Flower

extends Item

@export var _priority: int = 2
@export_category("Highlight Properties")
@export var _scale_factor: float = 1.0
@export var _glow_color: Color = Color(1.0, 0.95, 0.3)
@export var _glow_intensity: float = 5.0
@export var _glow_sharpness: float = 1.5
@export var meshes: Array[MeshInstance3D] = []
@export var mesh: MeshInstance3D

var highlighter: Highlighter

func _init() -> void:
	item_name = "Flower"
	item_weight = 0.1
	icon = preload("res://assets/items/twig/twig_icon.png")

func _ready() -> void:
	if mesh == null:
		if !meshes.is_empty():
			mesh = meshes.pick_random()
		else:
			return
	EventBus.interactable_selected.connect(_on_area_3d_body_entered)
	EventBus.interactable_exited.connect(_on_area_3d_body_exited)

	if !mesh.visible:
		mesh.show()

	highlighter = Highlighter.new(
		mesh,
		_scale_factor,
		_glow_color,
		_glow_intensity,
		_glow_sharpness
	)

func _on_area_3d_body_entered(body: Node3D) -> void:
	highlighter.highlight_object()


func _on_area_3d_body_exited(body: Node3D) -> void:
	highlighter.unhighlight_object()

func use() -> void:
	super._use_item()
