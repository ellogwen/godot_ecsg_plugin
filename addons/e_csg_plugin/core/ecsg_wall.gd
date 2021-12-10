tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(float, 0.1, 64.0, 0.05) var LENGTH = 4.0 setget set_length
export(float, 0.1, 8.0, 0.05) var WIDTH = 1.0 setget set_width
export(int, 1, 32) var SEGMENTS = 2 setget set_segments

func get_ecsg_type(): return "ECSGWall"

onready var csg_poly = $CSGPolygon

func set_length(val):
	val = clamp(val, 0.1, 64.0)
	LENGTH = val
	_calc_polygon()

func set_width(val):
	val = clamp(val, 0.1, 8.0)
	WIDTH = val
	if (csg_poly):
		csg_poly.depth = val
	_calc_polygon()

func set_segments(val):
	val = clamp(val, 1, 32)
	SEGMENTS = val
	_calc_polygon()

func get_top_row_points():
	var result = PoolVector3Array()
	for i in range(SEGMENTS + 1):
		result.push_back(get_top_row_point(i))
	return result

func get_top_row_point(index):
	if not csg_poly:
		return Vector3.ZERO
	index = index % (SEGMENTS + 1)
	var p = csg_poly.polygon[index]
	return Vector3(0.0, p.y, p.x)

func set_top_row_height(index, value):
	if not csg_poly:
		return
	csg_poly.polygon[index % (SEGMENTS + 1)].y = clamp(value, 0.1, 16.0)

func _calc_polygon():
	if not csg_poly:
		return

	var points = PoolVector2Array()
	var seg_len = LENGTH / SEGMENTS

	# top row
	for i in range(SEGMENTS + 1):
		var p_height = 1.0
		if csg_poly and i < csg_poly.polygon.size() / 2:
			p_height = get_top_row_point(i).y
		points.push_back(Vector2(i * seg_len, p_height))

	# bottom row
	for i in range(SEGMENTS, -1, -1):
		points.push_back(Vector2(i * seg_len, 0.0))

	csg_poly.polygon = points
