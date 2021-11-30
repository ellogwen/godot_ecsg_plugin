# namespace MeshCreator_Mesh
class_name MeshCreator_Mesh_Edge
extends Reference

var _a: MeshCreator_Mesh_Vertex
var _b: MeshCreator_Mesh_Vertex
var _meshIndex = -1

const EPSILON = 0.00001

func _init(a: MeshCreator_Mesh_Vertex, b: MeshCreator_Mesh_Vertex) -> void:
	_a = a
	_b = b	
	_meshIndex = -1
	
func get_mesh_index() -> int:
	return _meshIndex
	pass
	
func get_a() -> MeshCreator_Mesh_Vertex:
	return _a
	
func get_b() -> MeshCreator_Mesh_Vertex:
	return _b
	
func set_mesh_index(idx: int) -> void:
	_meshIndex = idx
	pass
	
func to_vector() -> Vector3:
	return _b.get_position() - _a.get_position()
	
func get_center() -> Vector3:
	return _a.get_position() + (to_vector() * 0.5)
	#return _a.get_position() + (_b.get_position() - _a.get_position()).normalized() * (length() * 0.5)

func length() -> float:
	return (_b.get_position() - _a.get_position()).length()
	
func matches(a: Vector3, b: Vector3, strict: bool = false) -> bool:
	if (strict):
		return (_a.get_position() == a and _b.get_position() == b)
	else:
		return ( (_a.get_position() == a and _b.get_position() == b) or (_a.get_position() == b and _b.get_position() == a) )

func is_point_on_edge(point: Vector3) -> bool:
	var a = _a.get_position()
	var b = _b.get_position()
	
	var AB = (b - a)
	var BA = (a - b)
	var AP = (point - a)
	var BP = (point - b)
	
	if (AB.normalized().is_equal_approx(AP.normalized()) and BA.normalized().is_equal_approx(BP.normalized())):
		return true
	
	return false
	
