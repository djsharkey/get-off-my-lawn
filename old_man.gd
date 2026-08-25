extends CharacterBody3D

@onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
	# TODO: Need to add a Area3D for detection and pass the body enter signal to the StateMachine function
