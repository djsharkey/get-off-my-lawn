extends State

var elapsedTime: float = 0.0
var transitionTimerActive: bool = false
# NOTE: Could become stamina instead that needs to recharge (would be on the OldMan reference itself)
# If moving to stamina, most likely don't need a timer and instead just update and check the value from physic_update using passed delta
@export var max_chase_time: int = 5

func enter(newData: Dictionary = {}) -> void:
	data = newData
	elapsedTime = 0.0
	transitionTimerActive = true

func physics_update(delta: float) -> void:
	elapsedTime += delta
	if transitionTimerActive && elapsedTime >= max_chase_time:
		transitioned.emit("ExhaustState", {})
		transitionTimerActive = false
		return
	
	if !data && !data["target"]:
		transitioned.emit("IdleState", {})
		return
	var target = data["target"]
	var direction = actor.global_position.direction_to(target.global_position)
	actor.velocity = direction * actor.speed
	actor.look_at(target.global_position + actor.velocity.normalized())
		
	if actor.global_position.distance_to(target.global_position) < 1.0:
		transitioned.emit("IdleState", {})
	

func transition_to_alternative_state(stateName: String, data: Dictionary):
	transitionTimerActive = false
	transitioned.emit(stateName, data)
	
