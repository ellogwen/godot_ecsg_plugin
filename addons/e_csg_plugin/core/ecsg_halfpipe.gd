tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(float, 0.0, 1.0) var STEEPNESS = 1.0 setget set_steepness

func set_steepness(val):
	val = clamp(val, 0.0, 1.0)
	STEEPNESS = val
	# 1.0 = y 0.3 / rad 0.5
	# 0.0 = y 0.8 / rad 1.0
	var use = abs(1.0 - val)
	var cyl = $CSGBox/CSGCylinder
	cyl.transform.origin.y = lerp(0.3, 0.8, use)
	cyl.radius = lerp(0.5, 1.0, use)
