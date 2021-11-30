tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(float, 0.1, 4.0, 0.05) var HEIGHT = 1.0 setget set_height
export(int, 3, 32) var SPIKES = 5 setget set_spikes
export(float, -0.99, 2.0) var INSET = 1.0 setget set_inset
export(bool) var HOLE = false setget set_hole
export(float, 0.0, 0.99) var HOLE_SIZE = 0.5 setget set_hole_size

func get_ecsg_type(): return "ECSGStar"

func set_height(val):
	val = clamp(val, 0.1, 4.0)
	HEIGHT = val
	$CSGPolygon/Cutter.scale.z = HEIGHT * 2.0
	$CSGPolygon/Cutter.transform.origin.z = val * 2.0 * 0.25
	_calc_polygon()

func set_spikes(val):
	val = clamp(val, 3, 32)
	SPIKES = val
	_calc_polygon()

func set_inset(val):
	val = clamp(val, -0.99, 2.0)
	INSET = val
	_calc_polygon()

func set_hole(val):
	HOLE = val
	$CSGPolygon/Cutter.visible = val

func set_hole_size(val):
	val = clamp(val, 0.0, 0.99)
	HOLE_SIZE = val
	$CSGPolygon/Cutter.set_scale(Vector3(val, val, HEIGHT * 2.0))
	$CSGPolygon/Cutter.transform.origin.z = (HEIGHT * 2.0) * 0.25

func get_spike_local_point(spike_idx):
	var angle = 360.0 / SPIKES
	var i = spike_idx % SPIKES
	var p = Vector2.UP.rotated(deg2rad(i * angle)) * 0.5
	return Vector3(p.x, HEIGHT, p.y)

func _calc_polygon():
	var points = PoolVector2Array()
	var angle = 360.0 / SPIKES

	for i in range(SPIKES):
		var p = Vector2.UP.rotated(deg2rad(i * angle)) * 0.5
		var p_next = p.normalized().rotated(deg2rad(angle)) * 0.5
		var p_mid = p + ((p_next - p) * 0.5)
		points.push_back(p)
		points.push_back(p_mid * (1.0 + INSET))

	$CSGPolygon.polygon = points
	$CSGPolygon.depth = HEIGHT
	$CSGPolygon/Cutter.polygon = points
