tool
extends ECSGObject

export (bool) var HOLE_Y = false setget set_hole_y_enabled
export (float, 0.0, 0.5) var HOLE_Y_SIZE = 0.25 setget set_hole_y_size
export (bool) var HOLE_X = false setget set_hole_x_enabled
export (float, 0.0, 0.5) var HOLE_X_SIZE = 0.25 setget set_hole_x_size
export (bool) var HOLE_Z = false setget set_hole_z_enabled
export (float, 0.0, 0.5) var HOLE_Z_SIZE = 0.25 setget set_hole_z_size

func get_ecsg_type(): return "ECSGBox"

func set_hole_y_enabled(val):
	HOLE_Y = val
	$CSGBox/CutY.visible = val

func set_hole_x_enabled(val):
	HOLE_X = val
	$CSGBox/CutX.visible = val

func set_hole_z_enabled(val):
	HOLE_Z = val
	$CSGBox/CutZ.visible = val

func set_hole_y_size(val):
	val = clamp(val, 0.0, 0.5)
	HOLE_Y_SIZE = val
	$CSGBox/CutY.width = val
	$CSGBox/CutY.depth = val

func set_hole_x_size(val):
	val = clamp(val, 0.0, 0.5)
	HOLE_X_SIZE = val
	$CSGBox/CutX.width = val
	$CSGBox/CutX.depth = val

func set_hole_z_size(val):
	val = clamp(val, 0.0, 0.5)
	HOLE_Z_SIZE = val
	$CSGBox/CutZ.width = val
	$CSGBox/CutZ.depth = val
