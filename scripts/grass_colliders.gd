extends MultiMeshInstance3D

#var tall_grass: MultiMeshInstance3D
var grass_dictionary: Dictionary[int, int] = {} # {key = area3d instance ID, val = multimesh index}
var cut_set: Dictionary = {} # can remove when releasing if cut_set.set(grass_idx, null) is removed below

#func _ready() -> void:
	#tall_grass = self
	#setup_triggers()


#func _process(delta: float) -> void:
	#material_override.set_shader_parameter("object_position", )


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_cut_all_grass"):
		cut_all_grass(0.1)
	if Input.is_action_just_pressed("debug_grow_all_grass"):
		grow_all_grass(10)


#func grow_grass():
	#for i in range(multimesh.instance_count):
		#var grass_transform: Transform3D = multimesh.get_instance_transform(i)
		#var new_transform: Transform3D = grass_transform.scaled_local(Vector3(1, 4, 1))
		#multimesh.set_instance_transform(i, new_transform)
	#print("grass is grown!")


func setup_triggers():
	var g_shape: CylinderShape3D = CylinderShape3D.new()
	g_shape.height = 1.5
	g_shape.radius = 0.2
	g_shape.margin = 0.04
	
	for i in range(multimesh.instance_count):
		var grass_area: Area3D = Area3D.new()
		var grass_col_shape: CollisionShape3D = CollisionShape3D.new()
		grass_col_shape.shape = g_shape
		grass_area.add_child(grass_col_shape)
		grass_area.set_script("res://scripts/grass_area3d.gd")
		add_child(grass_area)
		if !EventBus.grass_cut.is_connected(_on_cut_grass):
			EventBus.grass_cut.connect(_on_cut_grass)
		grass_area.global_transform = global_transform * multimesh.get_instance_transform(i)
		
		grass_dictionary.set(grass_area.get_instance_id(), i)
		print(grass_area.get_script())


func _on_cut_grass(grass_collider: Area3D):
	var grass_idx: int = grass_dictionary[grass_collider.get_instance_id()]
	if grass_collider == null || grass_dictionary.size() < 1 || cut_set.has(grass_idx):
		return
	var grass_transform: Transform3D = multimesh.get_instance_transform(grass_idx)
	multimesh.set_instance_transform(grass_idx, grass_transform.scaled(Vector3(1, 0.1, 1)))
	
	cut_set.set(grass_idx, null) # prevent from recutting cut grass while testing without removing ability to cut at all
	#grass_collider.queue_free() # Can swap to this when releasing
	cut_grass_progress()


func cut_grass_progress():
	return


func cut_all_grass(y_scale: float):
	for i in range(multimesh.instance_count):
		if cut_set.has(i) && y_scale < 1:
			continue
		var grass_transform: Transform3D = multimesh.get_instance_transform(i)
		var new_transform: Transform3D = grass_transform.scaled(Vector3(1, y_scale, 1))
		multimesh.set_instance_transform(i, new_transform)
		if y_scale < 1:
			cut_set.set(i, null)
		#await get_tree().create_timer(0.001).timeout
	if y_scale < 1:
		print("grass is cut!")
	elif y_scale > 1:
		cut_set.clear()
		print("grass has regrown!")


func grow_all_grass(y_scale: float):
	cut_all_grass(y_scale)
