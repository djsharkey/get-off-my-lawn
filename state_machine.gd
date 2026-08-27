class_name StateMachine
extends Node

## The state node that will run automatically when the game starts.
@export var initial_state: State

## Tracks the state that is currently running.
var current_state: State
## Dictionary to dynamically store reference paths to child state nodes.
var states: Dictionary = {}

func _ready() -> void:
	# Wait for the parent actor to be ready so states can safely reference it.
	await owner.ready
	
	# Dynamically register all child nodes that inherit from the State class
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			# Inject the parent actor dependency into the state
			child.actor = owner as CharacterBody3D

	if initial_state:
		current_state = initial_state
		current_state.enter()

# Route engine updates exclusively to the currently active state node
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func transition_to_state(new_state: String):
	on_child_transition(new_state)

## Changes execution flow from the current state to a target state.
func on_child_transition(new_state_name: String) -> void:
	var target_state = states.get(new_state_name.to_lower())
	if not target_state or target_state == current_state:
		return
		
	current_state.exit()
	target_state.enter()
	current_state = target_state
