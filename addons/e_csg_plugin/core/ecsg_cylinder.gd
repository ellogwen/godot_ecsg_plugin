tool
extends ECSGObject

export(bool) var CONE = false setget set_cone
export(bool) var HOLE = false setget set_hole
export(float, 0.0, 1.0) var HOLE_SIZE = 0.5 setget set_hole_size
export(bool) var FLAT_TOP = false setget set_flat_top
export(float, 0.1, 1.0) var FLAT_TOP_OFFSET = 0.5 setget set_flat_top_offset

func get_ecsg_type(): return "ECSGCylinder"

func set_cone(val):
	CONE = val
	$CSGCylinder.cone = val

func set_hole(val):
	HOLE = val
	$CSGCylinder/Hole.visible = val

func set_hole_size(val):
	val = clamp(val, 0.0, 1.0)
	HOLE_SIZE = val
	$CSGCylinder/Hole.radius = val

func set_flat_top(val):
	FLAT_TOP = val
	$CSGCylinder/Flatter.visible = val

func set_flat_top_offset(val):
	val = clamp(val, 0.1, 1.0)
	FLAT_TOP_OFFSET = val
	$CSGCylinder/Flatter.height = val * 2.0
