## Used to highlight an object in a scene using it's mesh
##
##
## The default parameters for glow properties can be overriden in the setup_highlight() method
class_name Highlighter

#it doesnt seem to break anything leaving @export in, so I'm leaving it in case we want to go back to using it in a scene
@export_category("Highlighter Defaults")
@export var _scale_factor: float = 1.0
@export var _glow_color: Color = Color(1.0, 0.95, 0.3)
@export var _glow_intensity: float = 5.0
@export var _glow_sharpness: float = 1.5

var mesh_object: MeshInstance3D
var outline_object: MeshInstance3D
var outline_material: ShaderMaterial
var lit: bool = false


## Sets up the Highlighter scene for adding a highlight glow to an object using that object's mesh.
## Requires a reference to the MeshInstance3D of the target object in order to create a fresnel glow mesh of the same shape.
func _init(
	mesh: MeshInstance3D,
	scale_factor: float = _scale_factor,
	glow_color: Color = _glow_color,
	glow_intensity: float = _glow_intensity,
	glow_sharpness: float = _glow_sharpness
) -> void:
	_scale_factor = scale_factor
	_glow_color = glow_color
	_glow_intensity = glow_intensity
	_glow_sharpness = glow_sharpness
	
	mesh_object = mesh
	outline_material = ShaderMaterial.new()
	outline_material.shader = load("res://shaders/highlight_glow.gdshader")
	outline_material.set_shader_parameter("glow_color", _glow_color)
	outline_material.set_shader_parameter("glow_intensity", _glow_intensity)
	outline_material.set_shader_parameter("glow_sharpness", _glow_sharpness)
	
	outline_object = MeshInstance3D.new()
	outline_object.mesh = mesh_object.mesh
	outline_object.set_surface_override_material(0, outline_material)
	outline_object.scale = Vector3.ONE * _scale_factor


#func setup_highlight(
	#mesh: MeshInstance3D,
	#scale_factor: float = _scale_factor,
	#glow_color: Color = _glow_color,
	#glow_intensity: float = _glow_intensity,
	#glow_sharpness: float = _glow_sharpness
#):
	#_scale_factor = scale_factor
	#_glow_color = glow_color
	#_glow_intensity = glow_intensity
	#_glow_sharpness = glow_sharpness
	#
	#mesh_object = mesh
	#outline_material = ShaderMaterial.new()
	#outline_material.shader = load("res://shaders/highlight_glow.gdshader")
	#outline_material.set_shader_parameter("glow_color", _glow_color)
	#outline_material.set_shader_parameter("glow_intensity", _glow_intensity)
	#outline_material.set_shader_parameter("glow_sharpness", _glow_sharpness)
	#
	#outline_object = MeshInstance3D.new()
	#outline_object.mesh = mesh_object.mesh
	#outline_object.set_surface_override_material(0, outline_material)
	#outline_object.scale = Vector3.ONE * _scale_factor


## Activate the glow mesh.
## Returns the lit status as a boolean.
func highlight_object():
	if lit:
		return lit
	#outline_object = MeshInstance3D.new()
	#outline_object.mesh = mesh_object.mesh
	#outline_object.set_surface_override_material(0, outline_material)
	#outline_object.scale = Vector3.ONE * _scale_factor
	mesh_object.add_child(outline_object)
	lit = true
	return lit


## Deactivate the glow mesh.
## Returns the lit status as a boolean.
func unhighlight_object():
	if !lit:
		return lit
	mesh_object.remove_child(outline_object)
	#outline_object.queue_free()
	lit = false
	return lit
