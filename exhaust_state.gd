extends State

var elapsedTime: float = 0.0
var transitionTimerActive: bool = false
@export var exhaust_time = 2.0

## Called when entering this state. Use for initializations or playing animations.
func enter(_data: Dictionary = {}) -> void:
	actor.toggle_detection(false)
	actor.velocity = Vector3.ZERO
	elapsedTime = 0.0
	transitionTimerActive = true
	
func exit() -> void:
	actor.toggle_detection(true)
	
## Replaces the main _physics_process() loop for this active state.
func physics_update(_delta: float) -> void:
	elapsedTime += _delta
	if transitionTimerActive && elapsedTime >= exhaust_time:
		transition_to_alternative_state("IdleState", {})

func transition_to_alternative_state(stateName: String, data: Dictionary):
	transitionTimerActive = false
	transitioned.emit(stateName, data)
