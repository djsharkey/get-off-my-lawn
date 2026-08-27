extends State

# Start pathing back to "home entrance" position3D (maybe there is more of these in the future and look for the closest one)
var homeSpawnLocation

func enter(_data: Dictionary = {}) -> void:
	homeSpawnLocation = actor.homeSpawnLocation
	
func physics_update(_delta: float) -> void:
	if !homeSpawnLocation:
		transitioned.emit("IdleState")
	var direction = actor.global_position.direction_to(homeSpawnLocation.global_position)
	actor.velocity = direction * actor.speed

	if actor.global_position.distance_to(homeSpawnLocation.global_position) < 1.0:
		actor.velocity = Vector3.ZERO
		transitioned.emit("IdleState")
