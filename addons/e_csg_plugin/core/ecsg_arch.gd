tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(int, 4, 36, 2) var SEGMENTS = 8 setget set_segments
export(float, 0.05, 8.0, 0.05) var HEIGHT = 1.0 setget set_height
export(float, 0.05, 8.0, 0.05) var BASE_WIDTH  = 1.0 setget set_base_width
export(float, 0.01, 1.0) var THICKNESS = 0.3 setget set_thickness
export(float, 0.05, 4.0) var DEPTH = 0.3 setget set_depth
export(String, "PARABOLIC") var ARCH_TYPE = "PARABOLIC" setget set_arch_type
export(bool) var FILLED = false setget set_filled
export(float, 0.0, 1.0) var SEGMENT_DISTRIBUTION = 0.5 setget set_segment_distribution

func get_ecsg_type(): return "ECSGArch"

onready var csg_poly = $CSGPolygon

func set_segments(val):
	val = clamp(val, 4, 36)
	val = val + (val % 2) # only even segments?
	SEGMENTS = val
	_calc_polygon()
	property_list_changed_notify()

func set_height(val):
	val = clamp(val, 0.05, 8.0)
	HEIGHT = val
	_calc_polygon()
	property_list_changed_notify()

func set_base_width(val):
	val = clamp(val, 0.05, 8.0)
	BASE_WIDTH = val
	_calc_polygon()
	property_list_changed_notify()

func set_thickness(val):
	val = clamp(val, 0.01, 1.0)
	THICKNESS = val
	_calc_polygon()
	property_list_changed_notify()

func set_depth(val):
	val = clamp(val, 0.05, 4.0)
	DEPTH = val
	_calc_polygon()
	property_list_changed_notify()

func set_arch_type(val):
	ARCH_TYPE = val
	_calc_polygon()
	property_list_changed_notify()

func set_segment_distribution(val):
	val = clamp(val, 0.0, 1.0)
	SEGMENT_DISTRIBUTION = val
	_calc_polygon()
	property_list_changed_notify()

func set_filled(val):
	FILLED = val
	_calc_polygon()
	property_list_changed_notify()

func _calc_polygon():
	if (not csg_poly):
		return
	var points = PoolVector2Array()
	match (ARCH_TYPE):
		"PARABOLIC":
			points = _parabolic_arch_points()
	csg_poly.polygon = points
	csg_poly.depth = DEPTH
	csg_poly.transform.origin.y = -(HEIGHT)
	csg_poly.transform.origin.z = DEPTH * 0.5

func _parabolic_arch_points() -> PoolVector2Array:
	var points = PoolVector2Array()

	var curve = Curve2D.new()

	# symmetric parabolic formula: y = a(x-h)² + k where vertex is (h, k)
	var even_segs = SEGMENTS + (SEGMENTS % 2)

	var a = -2.0
	var h = 0.0
	var k = 1.0

	# main parabola
	for i in range(-even_segs / 2, (even_segs / 2) + 1):
		var x = ((1.0 / even_segs) * i)
		var y = (HEIGHT * 2) * (a * pow((x - h), 2) + k)
		points.push_back(Vector2(x * BASE_WIDTH, y))

	# inner parabola
	if not FILLED:
		for i in range((even_segs / 2), -(even_segs / 2) - 1, -1):
			var height = (HEIGHT * 2) - (THICKNESS * 0.5)
			var width = BASE_WIDTH - (THICKNESS * 0.5)
			var x = ((1.0 / even_segs) * i)
			var y = height * (a * pow((x - h), 2) + k)
			var vec = Vector2(x * width, y + (THICKNESS * 0.5) * 0.5)
			points.push_back(vec)

	return points
