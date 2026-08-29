extends State

var transition_timer: SceneTreeTimer

func enter(_data: Dictionary = {}) -> void:
	if !actor.homeSpawnLocation:
		print("sadness?")
		return
	# If away from home, look to return after some time
	if actor.global_position.distance_to(actor.homeSpawnLocation.global_position) > 1.0:
		var random_wait_time = randf_range(2.0, 6.0)
		transition_timer = get_tree().create_timer(random_wait_time)
		transition_timer.timeout.connect(_on_timer_timeout)
	actor.animationPlayer.play("idle")
	
func exit() -> void:
	if transition_timer and transition_timer.timeout.is_connected(_on_timer_timeout):
		transition_timer.timeout.disconnect(_on_timer_timeout)

func _on_timer_timeout() -> void:	
	transitioned.emit("ReturnHomeState", {})
