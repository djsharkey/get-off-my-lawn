extends Area3D

#signal grass_cut(area_instance: Area3D) #remove if added to event bus

func _ready() -> void:
	body_entered.connect(_on_grass_entered)


func _on_grass_entered(body: Node3D) -> void:
	#print("someone's entered me lair!")
	if body.name != "Player":
		return
	EventBus.emit_signal("grass_cut", self)
