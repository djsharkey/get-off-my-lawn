extends MeshInstance3D


@onready var outline_mesh: MeshInstance3D = $Outline_mesh

#func _ready() -> void:
	#outline_mesh.visible = false


func _on_static_body_3d_mouse_entered() -> void:
	outline_mesh.visible = true


func _on_static_body_3d_mouse_exited() -> void:
	outline_mesh.visible = false
