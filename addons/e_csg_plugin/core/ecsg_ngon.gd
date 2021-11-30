tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(int, 3, 64) var SIDES = 6 setget set_sides
export(bool) var HOLE = false setget set_hole
export(float, 0.0, 1.0) var HOLE_SIZE = 0.8 setget set_hole_size

func get_ecsg_type(): return "ECSGNGon"

func set_sides(val):
	val = clamp(val, 3, 64)
	SIDES = val
	$CSGPolygon.spin_sides = val
	$CSGPolygon/Cutter.spin_sides = val

func set_hole(val):
	HOLE = val
	$CSGPolygon/Cutter.visible = val

func set_hole_size(val):
	val = clamp(val, 0.0, 1.0)
	HOLE_SIZE = val
	$CSGPolygon/Cutter.set_scale(Vector3(val, 1.2, val))
