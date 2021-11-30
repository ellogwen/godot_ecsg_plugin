# namespace MeshCreator_Mesh
extends Reference
# clockwise 3d triangle
class_name MeshCreator_Mesh_Triangle

var _a: Vector3
var _b: Vector3
var _c: Vector3
var _normal: Vector3

func _init(a: Vector3, b: Vector3, c: Vector3) -> void:
	set_points(a, b, c)
	
func set_points(a: Vector3, b: Vector3, c: Vector3) -> void:
	_a = a
	_b = b
	_c = c
	_calc_normal()
	pass
	
func get_a() -> Vector3:
	return _a
	
func get_b() -> Vector3:
	return _b
	
func get_c() -> Vector3:
	return _c
		
func get_n(index: int) -> Vector3:
	match(index):
		0: return _a
		1: return _b
		2: return _c
	printerr("Invalid triangle index", index)
	return Vector3.ZERO
		
func set_a(p: Vector3) -> void:
	set_point(0, p)
	pass
	
func set_b(p: Vector3) -> void:
	set_point(1, p)
	pass
	
func set_c(p: Vector3) -> void:
	set_point(2, p)
	pass
	
func set_point(index: int, point: Vector3) -> void:
	match(index):
		0: _a = point
		1: _b = point
		2: _c = point
	_calc_normal()
	pass
	
func get_side_length(index: int) -> float:
	match (index):
		0: return (_b - _a).length()
		1: return (_c - _b).length()
		2: return (_a - _c).length()
		_: return 0.0
		
func get_center() -> Vector3:
	return Vector3(
		(_a.x + _b.x + _c.x) / 3.0,
		(_a.y + _b.y + _c.y) / 3.0,
		(_a.z + _b.z + _c.z) / 3.0
	)
	pass
	
func get_normal() -> Vector3:
	return _normal
	
func _calc_normal():
	var u: Vector3 = (_b - _a)
	var v: Vector3 = (_c - _a)
	_normal = Vector3(
		(u.y * v.z) - (u.z * v.y),
		(u.z * v.x) - (u.x * v.z),
		(u.x * v.y) - (u.y * v.x)
	).normalized()
	pass
