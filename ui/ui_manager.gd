extends CanvasLayer

@onready var you_win_label: Label = %YouWinLabel
@onready var you_lose_label: Label = %YouLoseLabel
@onready var game_over_menu: ColorRect = $GameOverMenu

func ready() -> void:
#	TODO: Connect to win / lose signals
#	show game_over_menu
	pass
	
func _on_game_win():
	you_win_label.visible = true
	

func _on_game_lose():
	you_lose_label.visible = false
	
