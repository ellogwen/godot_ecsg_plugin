tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(float, 0.1, 4.0, 0.05) var HEIGHT = 0.5 setget set_height
export(int, 3, 32) var TEETH = 12 setget set_teeth
export(float, 0.0, 1.0) var TEETH_TIP_SIZE = 0.2 setget set_teeth_tip_size
export(float, 0.0, 1.0) var TEETH_BASE_SIZE = 0.5 setget set_teeth_base_size
export(float, 0.0, 1.0) var INSET = 0.2 setget set_inset
export(bool) var HOLE = true setget set_hole
export(float, 0.0, 0.99) var HOLE_SIZE = 0.5 setget set_hole_size

func get_ecsg_type(): return "ECSGGear"

onready var csg_poly = $CSGPolygon

func set_height(val):
	val = clamp(val, 0.1, 4.0)
	HEIGHT = val
	if csg_poly != null:
		$CSGPolygon/Cutter.height = HEIGHT
		$CSGPolygon/Cutter.transform.origin.z = -(HEIGHT * 0.5)
	_calc_polygon()

func set_teeth(val):
	val = clamp(val, 3, 32)
	TEETH = val
	_calc_polygon()

func set_teeth_tip_size(val):
	val = clamp(val, 0.0, 1.0)
	TEETH_TIP_SIZE = val
	_calc_polygon()

func set_teeth_base_size(val):
	val = clamp(val, 0.0, 1.0)
	TEETH_BASE_SIZE = val
	_calc_polygon()

func set_inset(val):
	val = clamp(val, 0.0, 1.0)
	INSET = val
	_calc_polygon()

func set_hole(val):
	HOLE = val
	if csg_poly != null:
		$CSGPolygon/Cutter.radius = HOLE_SIZE
		$CSGPolygon/Cutter.visible = val

func set_hole_size(val):
	val = clamp(val, 0.0, 0.99)
	HOLE_SIZE = val
	if csg_poly != null:
		$CSGPolygon/Cutter.radius = val
		$CSGPolygon/Cutter.transform.origin.z = -(HEIGHT * 0.5)

func get_tip_local_point(tooth_idx):
	var angle = 360.0 / TEETH
	var i = tooth_idx % TEETH
	var p = Vector2.UP.rotated(deg2rad(i * angle))
	return Vector3(p.x, HEIGHT, p.y)

func _calc_polygon():
	if (csg_poly == null):
		return

	var points = PoolVector2Array()
	var angle = 360.0 / TEETH

	for i in range(TEETH):
		var p = Vector2.UP.rotated(deg2rad(i * angle))
		var p_mid = p.normalized().rotated(deg2rad(angle * 0.5))
		var p_next = p.normalized().rotated(deg2rad(angle))
		var tip_offset_a = p.normalized().rotated(deg2rad(angle * TEETH_TIP_SIZE * 0.5))
		var tip_offset_b = p_next.normalized().rotated(-deg2rad(angle * TEETH_TIP_SIZE * 0.5))
		var base_offset_a = p_mid.normalized().rotated(-deg2rad(angle * TEETH_BASE_SIZE * 0.5)) * (1.0 - INSET)
		var base_offset_b = p_mid.normalized().rotated(deg2rad(angle * TEETH_BASE_SIZE * 0.5)) * (1.0 - INSET)

		points.push_back(tip_offset_a)
		points.push_back(base_offset_a)
		points.push_back(base_offset_b)
		points.push_back(tip_offset_b)

	csg_poly.polygon = points
	csg_poly.depth = HEIGHT

