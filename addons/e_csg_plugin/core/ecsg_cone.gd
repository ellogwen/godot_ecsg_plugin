tool
extends ECSGObject

export(int, 3, 128) var SIDES = 4 setget set_sides
export(float, 0.1, 32.0) var HEIGHT = 1.0 setget set_height
export(bool) var FLAT_TOP = false setget set_flat_top
export(float, 0.1, 0.99) var FLAT_TOP_OFFSET = 0.3 setget set_flat_top_offset

func get_ecsg_type(): return "ECSGCone"

func set_sides(val):
	val = clamp(val, 3, 128)
	SIDES = val
	$CSGCylinder.sides = val

func set_height(val):
	val = clamp(val, 0.1, 32.0)
	HEIGHT = val
	$CSGCylinder.height = val
	$CSGCylinder.transform.origin.y = val * 0.5
	$CSGCylinder/Flatter.transform.origin.y = val * 0.5

func set_flat_top(val):
	FLAT_TOP = val
	$CSGCylinder/Flatter.visible = val

func set_flat_top_offset(val):
	val = clamp(val, 0.1, 0.99)
	if (val == 0.5):
		val = 0.51 # godot bug?
	FLAT_TOP_OFFSET = val
	$CSGCylinder/Flatter.height = val * 2.0
