extends CharacterBody3D

@export var speed = 5.0

@onready var animationPlayer = $AnimationPlayer
@onready var stateMachine = $StateMachine

var homeSpawnLocation
var distractions = []
var playerRef: CharacterBody3D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func add_distraction(ref: Node3D):
	if ref not in distractions:
		distractions.append(ref)
	if stateMachine.current_state.name != "InvestigateState":
		stateMachine.transition_to_state("InvestigateState", {})

func remove_distraction(ref: Node3D):
	if ref in distractions:
		distractions.erase(ref)


func _on_dectection_area_body_entered(body):
	if body.name == "Player" && !playerRef:
		playerRef = body
		# TODO: Use LOS detection stuff to see if we should actually chase (or just raise suspision if we add that)
		stateMachine.transition_to_state("ChaseState", {"target": playerRef})

func _on_dectection_area_body_exited(body):
	if body.name == "Player" && playerRef:
		# TODO: Maybe transition into some sort of 'searching' state
		stateMachine.transition_to_previous_state()
		playerRef = null

func toggle_detection(val):
	if val != null:
		$DectectionArea.monitoring = val
		return
	$DectectionArea.monitoring = !$DectectionArea.monitoring
	
		
