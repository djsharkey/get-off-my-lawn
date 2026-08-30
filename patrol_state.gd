extends State

var patrol_point: Vector3

func enter(_data: Dictionary = {}) -> void:
	patrol_point = actor.patrol_spots[0]
	actor.nav_agent.set_target_position(patrol_point.global_position)

func physics_update(_delta: float) -> void:
	if !patrol_point:
		transitioned.emit("IdleState", {})
	var nav_target = actor.nav_agent.get_next_path_position()
	var direction = actor.global_position.direction_to(nav_target)
	actor.velocity = direction * actor.speed
	actor.look_at(nav_target + actor.velocity.normalized())
		
	if actor.global_position.distance_to(patrol_point.global_position) < 5.0:
		actor.velocity = Vector3.ZERO
		transitioned.emit("IdleState", {})


func next_patrol_point():
	patrol_point = 
	actor.nav_agent.set_target_position(patrol_point.global_position)
