extends State

var transition_timer: SceneTreeTimer
# NOTE: Could become stamina instead that needs to recharge (would be on the OldMan reference itself)
# If moving to stamina, most likely don't need a timer and instead just update and check the value from physic_update using passed delta
@export var max_chase_time: int = 5

func enter(newData: Dictionary = {}) -> void:
	data = newData
	transition_timer = get_tree().create_timer(max_chase_time)
	transition_timer.timeout.connect(_on_timer_timeout)

func physics_update(_delta: float) -> void:
	if !data && !data["target"]:
		transitioned.emit("IdleState", {})
	var direction = actor.global_position.direction_to(data["target"].global_position)
	actor.velocity = direction * actor.speed * 0.6
	actor.look_at(actor.global_position + actor.velocity.normalized())
		
	if actor.global_position.distance_to(data["target"].global_position) < 1.0:
		actor.velocity = Vector3.ZERO
		transitioned.emit("IdleState", {})

func _on_timer_timeout() -> void:
	transitioned.emit("ExhaustState", {})
