# namespace MeshCreator_Mesh
class_name MeshCreator_Mesh_Vertex
extends Reference
	
var _position: Vector3
var _color: Color	
var _meshIndex: int = -1

func _init(pos: Vector3) -> void:
	_position = pos
	_color = Color.black		
	_meshIndex = -1
	pass

func set_position(pos: Vector3) -> void:
	_position = pos
	
func get_position() -> Vector3:
	return _position
	
func set_color(color: Color) -> void:
	_color = color
	
func get_color() -> Color:
	return _color
	
func get_mesh_index() -> int:
	return _meshIndex	

func set_mesh_index(idx) -> void:
	_meshIndex = idx
	
func equals_position(other: MeshCreator_Mesh_Vertex) -> bool:
	return other.get_position() == get_position()
