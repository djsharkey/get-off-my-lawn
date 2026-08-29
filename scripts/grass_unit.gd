extends MeshInstance3D

var cut: bool = false

func _ready() -> void:
	#tall_grass = self
	setup_grass()


#func _process(delta: float) -> void:
	#material_override.set_shader_parameter("object_position", )


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_cut_all_grass"):
		cut_all_grass(1)
	if Input.is_action_just_pressed("debug_grow_all_grass"):
		grow_all_grass(10)


func setup_grass():
	if !EventBus.grass_cut.is_connected(_on_cut_grass):
		EventBus.grass_cut.connect(_on_cut_grass)


func _on_cut_grass(grass_collider: Area3D):
	if cut || grass_collider.get_instance_id() != $Area3D.get_instance_id():
		return
	scale = Vector3(1, 1, 1)
	cut = true
	cut_grass_progress()


func cut_grass_progress():
	return


func cut_all_grass(y_scale: float):
	if cut && y_scale > 2:
		scale = Vector3(1, y_scale, 1)
		cut = false
		print("Grass has regrown!")
	elif !cut && y_scale < 2:
		scale = Vector3(1, y_scale, 1)
		cut = true
		print("Grass has been cut!")


func grow_all_grass(y_scale: float):
	cut_all_grass(y_scale)
