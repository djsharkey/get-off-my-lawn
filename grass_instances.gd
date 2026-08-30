extends MultiMeshInstance3D

@export var instance_count: int = 200000
@export var field_size: Vector2 = Vector2(67.0, 30.0)
@export var field_offset: Vector2 = Vector2(0.0, 13.0)
@export var grass_mask: GrassMask

func _ready() -> void:
	scatter()

	var mat := multimesh.mesh.surface_get_material(0) as ShaderMaterial
	if mat == null:
		print("No ShaderMaterial found on mesh surface")
		return

	if grass_mask == null:
		print("grass_mask not assigned in the Inspector")
		return

	mat.set_shader_parameter("grass_mask", grass_mask.get_texture())
	mat.set_shader_parameter("field_origin", grass_mask.field_origin)
	mat.set_shader_parameter("field_size", grass_mask.field_size)

func scatter() -> void:
	multimesh.instance_count = 0
	multimesh.instance_count = instance_count

	for i in range(instance_count):
		var x := randf_range(-field_size.x * 0.5 - field_offset.x, field_size.x * 0.5 - field_offset.x)
		var z := randf_range(-field_size.y * 0.5 - field_offset.y, field_size.y * 0.5 - field_offset.y)
		var y := 0.0

		var rot_y := randf_range(0.0, TAU)
		var scale := randf_range(0.8, 1.3)

		var basis := Basis(Vector3.UP, rot_y).scaled(Vector3(scale, scale, scale))
		var xform := Transform3D(basis, Vector3(x, y, z))

		multimesh.set_instance_transform(i, xform)
