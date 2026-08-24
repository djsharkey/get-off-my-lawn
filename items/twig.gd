class_name Twig

extends Item
	

func _init() -> void:
	item_name = "Twig"
	item_weight = 0.5
	icon = preload("res://assets/items/twig/twig_icon.png")
		

func use() -> void:
	super._use_item()
	
