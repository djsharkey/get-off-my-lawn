extends Node3D

@onready var distraction = $Distraction_Parent/Distraction
@onready var oldman = $OldMan

func _ready():
	oldman.homeSpawnLocation = $FrontDoorLocation
	distraction.connect("distraction_enabled", new_distraction_activated)
	distraction.connect("distraction_disabled", distraction_deactivating)	
	
func new_distraction_activated(ref: Node3D):
	oldman.add_distraction(ref)

func distraction_deactivating(ref: Node3D):
	oldman.remove_distraction(ref)


func _on_button_pressed():
	distraction.active = !distraction.active
