extends State

var elapsedTime: float = 0.0
var transitionTimerActive: bool = false
var waitTime: float = 0.0

func enter(newData: Dictionary = {}) -> void:
	if !actor.homeSpawnLocation:
		return
	# If away from home, look to return after some time
	# TODO: Rework how/when return to home happens from since this is kinda jank
	if actor.global_position.distance_to(actor.homeSpawnLocation.global_position) > 1.0:
		waitTime = randf_range(2.0, 6.0)
	elapsedTime = 0.0
	transitionTimerActive = true

func physics_update(delta: float) -> void:
	elapsedTime += delta
	if transitionTimerActive && elapsedTime >= waitTime:
		transition_to_alternative_state("ReturnHomeState", {})
		return

func transition_to_alternative_state(stateName: String, data: Dictionary):
	transitionTimerActive = false
	transitioned.emit(stateName, data)
