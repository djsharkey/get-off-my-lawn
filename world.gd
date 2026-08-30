extends Node3D

@export var points_to_win: float = 25000
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
	var sb = %ProgressBar.get_theme_stylebox("fill") as StyleBoxFlat
	match task:
		Constants.Tasks.TOTAL:
			%ProgressBar/Label.text = "Overall"
			%ProgressBar.value = task_points[Constants.Tasks.TOTAL]
			if sb:
				sb.bg_color = Color(0.929, 0.592, 0.075, 1.0)
		Constants.Tasks.CUT_GRASS:
			%ProgressBar/Label.text = "Grass Cut"
			%ProgressBar.value = task_points[task]
			if sb:
				sb.bg_color = Color(0.0, 0.765, 0.286, 1.0)
		Constants.Tasks.DEBRIS:
			%ProgressBar/Label.text = "Debris Cleared and Composted"
			%ProgressBar.value = task_points[task]
			if sb:
				sb.bg_color = Color(0.764, 0.556, 0.736, 1.0)
		Constants.Tasks.WEEDS:
			%ProgressBar/Label.text = "Weeds Picked and Composted"
			%ProgressBar.value = task_points[task]
			if sb:
				sb.bg_color = Color(0.481, 0.687, 0.611, 1.0)
	if task != Constants.Tasks.TOTAL:
		%ProgressBar/ResetTimer.start()


func _check_point_total(points: float):
	if  points >= points_to_win:
		display_task_progress(Constants.Tasks.TOTAL)
		await get_tree().create_timer(2).timeout
		# TODO: Switch to "Victory" screen instead
		SceneSwitcher.change_scene("res://main_menu.tscn")


func _progress_increased(task: Constants.Tasks, points: float):
	#print("YOU GOT POINTS")
	task_points[task] += points
	task_points[Constants.Tasks.TOTAL] += points/2
	_check_point_total(task_points[Constants.Tasks.TOTAL])
	if task_points[task] >= points_to_win:
		display_task_progress(Constants.Tasks.TOTAL)
	else:
		display_task_progress(task)


func _task_progress_requested(task: Constants.Tasks):
	display_task_progress(task)


func _on_reset_timer_timeout():
	display_task_progress(Constants.Tasks.TOTAL)
