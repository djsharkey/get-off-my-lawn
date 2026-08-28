extends State

var transition_timer: SceneTreeTimer
@export var exhaust_time = 2.0

## Called when entering this state. Use for initializations or playing animations.
func enter(_data: Dictionary = {}) -> void:
	actor.toggle_detection(false)
	actor.velocity = Vector3.ZERO
	transition_timer = get_tree().create_timer(exhaust_time)
	transition_timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout() -> void:
	actor.toggle_detection(true)
	transitioned.emit("IdleState", {})
