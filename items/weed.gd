class_name Weed

extends Item

@export var _priority: int = 1
@export_category("Highlight Properties")
@export var _scale_factor: float = 1.0
@export var _glow_color: Color = Color(1.0, 0.95, 0.3)
@export var _glow_intensity: float = 5.0
@export var _glow_sharpness: float = 1.5
@export_category("Mesh Properties")
@export var meshes: Array[MeshInstance3D] = []
@export var mesh: MeshInstance3D

var highlighter: Highlighter
var pulled = false

func _init() -> void:
	item_name = "Weed"
	item_weight = 0.1
	icon = preload("res://assets/items/twig/twig_icon.png")
	item_type = Constants.ItemTypes.WEED
	freeze = true


func _ready() -> void:
	super._ready()
	$CollisionShape3D.disabled = true
	if mesh == null:
		if !meshes.is_empty():
			mesh = meshes.pick_random()
		else:
			return

	item_type = Constants.ItemTypes.WEED
	highlighter = Highlighter.new(
		mesh,
		_scale_factor,
		_glow_color,
		_glow_intensity,
		_glow_sharpness
	)

	if !mesh.visible:
		mesh.show()

	EventBus.interactable_selected.connect(_on_flower_selected)
	EventBus.interactable_unselected.connect(_on_flower_unselected)


func _on_flower_selected(interactable: Interactable, player: Player) -> void:
	if interactable.interactable_object_id == get_instance_id():
		highlighter.highlight_object()


func _on_flower_unselected(interactable: Interactable) -> void:
	highlighter.unhighlight_object()


func drop_item(direction: Vector3):
	super.drop_item(direction)
	$CollisionShape3D.disabled = false


func use() -> void:
	super._use_item()
