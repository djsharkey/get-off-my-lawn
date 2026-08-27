extends Node3D

@export var _scale_factor: float = 1.0
@export var _glow_color: Color = Color(1.0, 0.95, 0.3)
@export var _glow_intensity: float = 2.0
@export var _glow_sharpness: float = 2.0

@onready var mesh: MeshInstance3D = $weed

#example highlighter use
var highlighter: Highlighter

func _ready() -> void:
	highlighter = Highlighter.new(
		mesh,
		_scale_factor,
		_glow_color,
		_glow_intensity,
		_glow_sharpness
	)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name != "Player":
		return
	highlighter.highlight_object()




func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name != "Player":
		return
	highlighter.unhighlight_object()
