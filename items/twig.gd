class_name Twig

extends Item

@export var _priority: int = 0
@export_category("Highlight Properties")
@export var _scale_factor: float = 1.0
@export var _glow_color: Color = Color(1.0, 0.95, 0.3)
@export var _glow_intensity: float = 5.0
@export var _glow_sharpness: float = 1.5

@onready var mesh: MeshInstance3D = $MeshInstance3D

var highlighter: Highlighter

func _init() -> void:
	item_name = "Twig"
	item_weight = 0.5
	icon = preload("res://assets/items/twig/twig_icon.png")
	item_type = Constants.ItemTypes.TWIG
	# needs to connect to the same logic that propmts the interaction button and needs a way to distinguish which twig is making the event to be interacted with
	#EventBus.interactable_selected.connect()
	#EventBus.interactable_exited.connect()

func _ready() -> void:
	super._ready()
	highlighter = Highlighter.new(
	 	mesh,
	 	_scale_factor,
	 	_glow_color,
	 	_glow_intensity,
	 	_glow_sharpness
	 )

	EventBus.interactable_selected.connect(_on_twig_selected)
	EventBus.interactable_unselected.connect(_on_twig_unselected)

func _on_twig_selected(interactable: Interactable) -> void:
	highlighter.highlight_object()


func _on_twig_unselected(interactable: Interactable) -> void:
	highlighter.unhighlight_object()

func use() -> void:
	super._use_item()
