extends Node3D

@export var default_speed := 4.0
@export var transition_speed := 2.0

@onready var player := $"../Player"
@onready var old_man := $"../OldMan"

var target: CharacterBody3D
var is_transition := false

func _ready() -> void:
	target = player

func _physics_process(delta: float) -> void:
	var desired_pos := target.global_position
	var speed := transition_speed if is_transition else default_speed
	global_position = global_position.lerp(desired_pos, 1.0 - exp(-speed * delta))

func focus_on(new_target: Node3D, duration := 1.0) -> void:
	is_transition = true
	target = new_target
	await get_tree().create_timer(duration).timeout
	is_transition = false
