tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(float, 0.0, 3.0, 0.05) var HEIGHT = 1.0 setget set_height
export(float, 0.0, 8.0, 0.05) var DEPTH = 1.0 setget set_depth
export(float, 0.0, 4.0, 0.05) var WIDTH = 1.0 setget set_width

func get_ecsg_type(): return "ECSGRamp"

func set_height(val):
	val = clamp(val, 0.0, 3.0)
	HEIGHT = val
	$CSGPolygon.polygon[1].y = val
	property_list_changed_notify()

func set_depth(val):
	val = clamp(val, 0.0, 8.0)
	DEPTH = val
	$CSGPolygon.polygon[2].x = val
	property_list_changed_notify()

func set_width(val):
	val = clamp(val, 0.0, 4.0)
	WIDTH = val
	$CSGPolygon.transform.origin.x = -(val * 0.5)
	$CSGPolygon.depth = val
	property_list_changed_notify()
