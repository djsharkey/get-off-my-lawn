extends State

var activeDistraction: Node3D

func enter(_data: Dictionary = {}) -> void:
	activeDistraction = actor.distractions[0]

func physics_update(_delta: float) -> void:
	if !activeDistraction:
		transitioned.emit("IdleState", {})
	var direction = actor.global_position.direction_to(activeDistraction.global_position)
	actor.velocity = direction * actor.speed
	actor.look_at(actor.global_position + actor.velocity.normalized())
		
	if actor.global_position.distance_to(activeDistraction.global_position) < 5.0:
		actor.velocity = Vector3.ZERO
		transitioned.emit("IdleState", {})
