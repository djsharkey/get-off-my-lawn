extends MeshInstance3D

@export var _priority: int = 0
@export_category("Highlight Properties")
@export var _scale_factor: float = 1.0
@export var _glow_color: Color = Color(1.0, 0.95, 0.3)
@export var _glow_intensity: float = 5.0
@export var _glow_sharpness: float = 1.5

@onready var interactable: Interactable = $Interactable

var highlighter: Highlighter
var task: Constants.Tasks = Constants.Tasks.DEBRIS
var points: float = 0.1

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
	EventBus.interactable_selected.connect(_on_area_3d_body_entered)
	EventBus.interactable_exited.connect(_on_area_3d_body_exited)
	interactable.interacted.connect(_on_discarded)
	return


func _on_discarded(obj: Node3D):
	var player = obj as Player #?
	if player.equipped_item == null:
		return
	var item = player.equipped_item
	print(item.name + " has been discarded")
	item.queue_free()
	EventBus.progress_increased.emit(task, points)
	return


func _on_area_3d_body_entered(body: Node3D) -> void:
	# currently no way to tell if player is holding something that can be discarded, so it will always highlight when in range
	highlighter.highlight_object()
	EventBus.task_progress_requested.emit(task) # show progress of debris task for 5 sec



func _on_area_3d_body_exited(body: Node3D) -> void:
	highlighter.unhighlight_object()
