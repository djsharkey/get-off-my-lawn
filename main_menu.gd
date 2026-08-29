extends Control


func _on_start_button_pressed():
	#TODO: Switch scene to world
	SceneSwitcher.change_scene("res://world.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
