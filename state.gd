class_name State
extends Node

## Emitted when the state wants to transition to another state.
signal transitioned(state_name: String)

## Reference to the main actor (e.g., Player or Enemy) using this state machine.
var actor: CharacterBody3D

## Called when entering this state. Use for initializations or playing animations.
func enter(_data: Dictionary = {}) -> void:
	pass

## Called when exiting this state. Use for cleanup or clearing values.
func exit() -> void:
	pass

## Replaces the main _process() loop for this active state.
func update(_delta: float) -> void:
	pass

## Replaces the main _physics_process() loop for this active state.
func physics_update(_delta: float) -> void:
	pass

## Replaces the main _unhandled_input() function for this active state.
func handle_input(_event: InputEvent) -> void:
	pass
