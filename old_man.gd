extends CharacterBody3D

@export var speed = 3.0
@export var visibilityPercentageThreshold = 50

@onready var animationPlayer = $AnimationPlayer
@onready var stateMachine = $StateMachine
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var shouldCheckLOS: bool = false
var canSeePlayer: bool = false
var losSourceMesh: MeshInstance3D
var losTargetMesh: MeshInstance3D
var losSourceVertices: Array[Vector3] = []
var losTargetVertices: Array[Vector3] = []
var frameCount = 0
var losFrameDelay = 5
var losCollisionMask = 1 << 3

var homeSpawnLocation
var distractions = []
var playerRef: Player

#Navigation Agent/Mesh vars
var target: Vector3

func _ready():
	losSourceMesh = $RaycasterMesh
	losSourceVertices = _get_vertices(losSourceMesh.mesh)

func _physics_process(delta):
	frameCount += 1
	if !shouldCheckLOS:
		canSeePlayer = false
	elif frameCount % losFrameDelay == 0:
		var visibilityPerc = getLOSVisibilityPercentage()
		canSeePlayer = visibilityPerc >= visibilityPercentageThreshold
		
	# Think about any necassary state transitions
	match stateMachine.current_state.name:
		"ChaseState":
			if !canSeePlayer:
				# TODO: transition to a "searching" state instead
				stateMachine.transition_to_previous_state()
		"ExhaustState":
			# Don't process into another state from Exhaust
			pass
		_:
			if canSeePlayer:
				stateMachine.transition_to_state("ChaseState", {"target": playerRef})

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func getLOSVisibilityPercentage() -> float:
	if !playerRef:
		return 0.0
	if !losTargetMesh || losTargetVertices:
		losTargetMesh = playerRef.get_raycast_visibility_mesh()
		losTargetVertices = _get_vertices(losTargetMesh.mesh)
	var sourceTransform = losSourceMesh.global_transform
	var targetTransform = losTargetMesh.global_transform
	var worldSpaceState = get_world_3d().direct_space_state
	
	# Cast them rays!
	var successfulRayCount = 0
	var count = 0
	var excludeList: Array[RID] = [self.get_rid(), playerRef.get_rid()]
	for sourceVert in losSourceVertices:
		var sourceVertGlobalTransform = sourceTransform * sourceVert
		for targetVert in losTargetVertices:
			count += 1
			var targetVertGlobalTransform = targetTransform * targetVert
			
			# Configure Raycast

			var rayQuery = PhysicsRayQueryParameters3D.create(sourceVertGlobalTransform, targetVertGlobalTransform, losCollisionMask)
			rayQuery.collide_with_areas = true
			rayQuery.exclude = excludeList
			var result = worldSpaceState.intersect_ray(rayQuery)
			if result.is_empty():
				successfulRayCount += 1
	# Calc percentage
	return (float(successfulRayCount) / (float(losSourceVertices.size() * losTargetVertices.size()))) * 100

func _get_vertices(mesh: Mesh) -> Array[Vector3]:
	var verts: Array[Vector3] = []
	if mesh is ArrayMesh or mesh is PrimitiveMesh:
		var arrays = mesh.get_mesh_arrays()
		if arrays.size() > Mesh.ARRAY_VERTEX:
			var raw_verts = arrays[Mesh.ARRAY_VERTEX]
			if raw_verts:
				verts.assign(raw_verts)
	return verts

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
		shouldCheckLOS = true
		

func _on_dectection_area_body_exited(body):
	if body.name == "Player" && playerRef:
		shouldCheckLOS = false
		stateMachine.transition_to_previous_state()
		playerRef = null


func toggle_detection(val):
	if val != null:
		$DectectionArea.set_deferred("monitoring", val)
		return
	$DectectionArea.set_deferred("monitoring", !$DectectionArea.monitoring)
	
		


func _on_child_grabbin_range_area_body_entered(body):
	if body is Player:
		SceneSwitcher.change_scene("res://main_menu.tscn")
