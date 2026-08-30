extends State

# Start pathing back to "home entrance" position3D (maybe there is more of these in the future and look for the closest one)
var homeSpawnLocation

func enter(_data: Dictionary = {}) -> void:
	homeSpawnLocation = actor.homeSpawnLocation
	actor.nav_agent.set_target_position(homeSpawnLocation.global_position)
	
func physics_update(_delta: float) -> void:
	if !homeSpawnLocation:
		transitioned.emit("IdleState", {})
	var nav_target = actor.nav_agent.get_next_path_position()
	var direction = actor.global_position.direction_to(nav_target)
	actor.velocity = direction * actor.speed
	actor.look_at(nav_target + actor.velocity.normalized())
	actor.rotation.x = 0
	actor.rotation.z = 0

	if actor.global_position.distance_to(homeSpawnLocation.global_position) < 1.0:
		actor.velocity = Vector3.ZERO
		# TODO: Need to go into "enter home" state instead
		transitioned.emit("IdleState", {})
