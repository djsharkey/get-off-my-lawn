extends CharacterBody3D

@export var speed = 5.0

@onready var animationPlayer = $AnimationPlayer
@onready var stateMachine = $StateMachine

var homeSpawnLocation
var distractions = []

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func add_distraction(ref: Node3D):
	if ref not in distractions:
		distractions.append(ref)
	if stateMachine.current_state.name != "InvestigateState":
		stateMachine.transition_to_state("InvestigateState")

func remove_distraction(ref: Node3D):
	if ref in distractions:
		distractions.erase(ref)
