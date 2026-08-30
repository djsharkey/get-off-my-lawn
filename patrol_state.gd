extends State

var patrol_point
var patrol_array: Array[Vector3]

var elapsedTime: float = 0.0
var patrolTimerActive: bool = false
var waitTime: float = 0.0

func enter(_data: Dictionary = {}) -> void:
	if patrol_array.size() < 1:
		patrol_array = actor.patrol_spots.duplicate()
	patrol_point = patrol_array.pop_front()
	actor.nav_agent.set_target_position(patrol_point)
	print("start Patrolling!")

func physics_update(delta: float) -> void:
	elapsedTime += delta
	if !patrol_point:
		transitioned.emit("IdleState", {})
	if patrolTimerActive && elapsedTime >= waitTime:
		next_patrol_point()
		patrolTimerActive = false
		return
	var nav_target = actor.nav_agent.get_next_path_position()
	var direction = actor.global_position.direction_to(nav_target)
	actor.velocity = direction * actor.speed
	actor.look_at(nav_target + actor.velocity.normalized())
	actor.rotation.x = 0
	actor.rotation.z = 0
		
	if actor.global_position.distance_to(patrol_point) < 0.5 && !patrolTimerActive:
		print("point reached! "+ str(nav_target))
		actor.velocity = Vector3.ZERO
		elapsedTime = 0.0
		patrolTimerActive = true
		


func next_patrol_point():
	print("Getting next patrol point")
	patrol_point = patrol_array.pop_front()
	waitTime = randf_range(2.0, 5.0)
	if !patrol_point:
		print("go home old man!")
		transitioned.emit("ReturnHomeState", {})
		return
	actor.nav_agent.set_target_position(patrol_point)
