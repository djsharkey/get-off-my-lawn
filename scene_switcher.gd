extends Node

signal scene_changed()

const SCENE_CHANGE_DELAY = 0.5

@onready var animationPlayer = $AnimationPlayer
@onready var overlayColorRect = $Control/ColorRect

func change_scene(path: String):
	self.layer = 1
	get_tree().paused = true
	await get_tree().create_timer(SCENE_CHANGE_DELAY).timeout
	
	# Fade out
	animationPlayer.play("fade")
	await animationPlayer.animation_finished
	
	# Change level
	get_tree().change_scene_to_file(path)
	
	# Fade in
	animationPlayer.play_backwards("fade")
	await animationPlayer.animation_finished
	get_tree().paused = false
	self.layer = -1
