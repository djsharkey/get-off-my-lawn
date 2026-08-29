extends MeshInstance3D

@export var _priority: int = 0
@export_category("Highlight Properties")
@export var _scale_factor: float = 1.0
@export var _glow_color: Color = Color(1.0, 0.95, 0.3)
@export var _glow_intensity: float = 5.0
@export var _glow_sharpness: float = 1.5

var highlighter: Highlighter
var task: Constants.Tasks = Constants.Tasks.DEBRIS
var points: float = 0.5

func _ready() -> void:
	#connect to discard signal
	# .connect(_on_discard_plant)
	highlighter = Highlighter.new(
		self,
		_scale_factor,
		_glow_color,
		_glow_intensity,
		_glow_sharpness
	)
	return
	
	
func _on_discard_plant(obj: Node3D):
	print(obj.name + " has been discarded")
	obj.queue_free()
	EventBus.progress_increased.emit(task, points)
	return


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name != "Player":
		return
	highlighter.highlight_object()



func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name != "Player":
		return
	highlighter.unhighlight_object()
