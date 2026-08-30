extends Node
class_name GrassMask

@export var resolution: int = 512
@export var field_origin: Vector2 = Vector2(-33.5, -28.0)
@export var field_size: Vector2 = Vector2(67.0, 30.0)
@export var stamp_radius_px: int = 8
@export var update_every_n_stamps: int = 3

var _image: Image
var _texture: ImageTexture
var _stamps_since_update: int = 0

func _init() -> void:
	_image = Image.create(resolution, resolution, false, Image.FORMAT_R8)
	_image.fill(Color(0, 0, 0))
	_texture = ImageTexture.create_from_image(_image)

func get_texture() -> ImageTexture:
	return _texture

func stamp_world_position(world_pos: Vector3) -> void:
	var px := int((world_pos.x - field_origin.x) / field_size.x * resolution)
	var py := int((world_pos.z - field_origin.y) / field_size.y * resolution)

	for y in range(py - stamp_radius_px, py + stamp_radius_px):
		if y < 0 or y >= resolution:
			continue
		for x in range(px - stamp_radius_px, px + stamp_radius_px):
			if x < 0 or x >= resolution:
				continue
			if Vector2(x - px, y - py).length() <= stamp_radius_px:
				# FIXME add completion increment here
				_image.set_pixel(x, y, Color(1, 0, 0))

	_stamps_since_update += 1
	if _stamps_since_update >= update_every_n_stamps:
		_texture.update(_image)
		_stamps_since_update = 0
