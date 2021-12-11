tool
extends ECSGObject

export(float, 0.1, 128.0, 0.05) var HEIGHT = 1.0 setget set_height
export(float, 0.1, 128.0) var RADIUS = 0.5 setget set_radius
export(bool) var CONE = false setget set_cone
export(bool) var HOLE = false setget set_hole
export(float, 0.01, 0.99) var HOLE_SIZE = 0.5 setget set_hole_size
export(bool) var FLAT_TOP = false setget set_flat_top
export(float, 0.1, 1.0) var FLAT_TOP_OFFSET = 0.5 setget set_flat_top_offset

func get_ecsg_type(): return "ECSGCylinder"

func set_height(val):
	val = clamp(val, 0.1, 128.0)
	HEIGHT = val
	$CSGCylinder.height = HEIGHT
	$CSGCylinder/Hole.height = HEIGHT
	$CSGCylinder.transform.origin.y = HEIGHT * 0.5
	$CSGCylinder/Flatter.height = HEIGHT * FLAT_TOP_OFFSET
	$CSGCylinder/Flatter.transform.origin.y = HEIGHT * 0.5

func set_radius(val):
	val = clamp(val, 0.1, 128.0)
	RADIUS = val
	$CSGCylinder.radius = RADIUS
	$CSGCylinder/Hole.radius = RADIUS * HOLE_SIZE
	$CSGCylinder/Flatter.width = RADIUS * 2.0
	$CSGCylinder/Flatter.depth = RADIUS * 2.0

func set_cone(val):
	CONE = val
	$CSGCylinder.cone = val

func set_hole(val):
	HOLE = val
	$CSGCylinder/Hole.visible = val

func set_hole_size(val):
	val = clamp(val, 0.01, 0.99)
	HOLE_SIZE = val
	$CSGCylinder/Hole.radius = RADIUS * HOLE_SIZE

func set_flat_top(val):
	FLAT_TOP = val
	$CSGCylinder/Flatter.visible = val

func set_flat_top_offset(val):
	val = clamp(val, 0.1, 1.0)
	FLAT_TOP_OFFSET = val
	$CSGCylinder/Flatter.height = HEIGHT * val
	$CSGCylinder/Flatter.transform.origin.y = HEIGHT * 0.5
