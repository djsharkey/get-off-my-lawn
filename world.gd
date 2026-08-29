extends Node3D

@export var points_to_win: float = 10
@onready var distraction = $Distraction_Parent/Distraction
@onready var oldman = $OldMan

var task_points: Dictionary = {
	Constants.Tasks.CUT_GRASS: 0.0,
	Constants.Tasks.DEBRIS: 0.0,
	Constants.Tasks.WEEDS: 0.0,
	Constants.Tasks.TOTAL: 0.0
}

func _ready():
	oldman.homeSpawnLocation = $FrontDoorLocation
	distraction.connect("distraction_enabled", new_distraction_activated)
	distraction.connect("distraction_disabled", distraction_deactivating)
	EventBus.progress_increased.connect(_progress_increased)
	EventBus.task_progress_requested.connect(_task_progress_requested)
	
func new_distraction_activated(ref: Node3D):
	oldman.add_distraction(ref)

func distraction_deactivating(ref: Node3D):
	oldman.remove_distraction(ref)


func _on_button_pressed():
	distraction.active = !distraction.active


func display_task_progress(task: Constants.Tasks):
	%ProgressBar.value = task_points[task]
	if task == Constants.Tasks.TOTAL:
		return
	await get_tree().create_timer(5).timeout
	%ProgressBar.value = task_points[Constants.Tasks.TOTAL]


func _check_point_total(points: float):
	if  points >= points_to_win:
		# TODO: Switch to "Victor" screen instead
		SceneSwitcher.change_scene("res://main_menu.tscn")


func _progress_increased(task: Constants.Tasks, points: float):
	task_points[task] += points
	task_points[Constants.Tasks.TOTAL] += points/3
	_check_point_total(task_points[Constants.Tasks.TOTAL])
	display_task_progress(task)


func _task_progress_requested(task: Constants.Tasks):
	display_task_progress(task)
