extends Node3D

signal distraction_enabled(parentRef: Node3D)
signal distraction_disabled(parentRef: Node3D)


@onready var parentRef = get_parent()
@onready var active: bool = false:
	set(newVal):
		if active == newVal:
			pass
		if newVal:
			distraction_enabled.emit(parentRef)
		else:
			distraction_disabled.emit(parentRef)
		active = newVal
