tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(int, 2, 32) var STEPS = 6 setget set_steps
export(float, 0.1, 8.0, 0.05) var HEIGHT = 1.0 setget set_height
export(float, 0.1, 4.0, 0.05) var WIDTH = 1.0 setget set_width
export(float, 0.1, 8.0, 0.05) var DEPTH = 1.0 setget set_depth
export(String, "FILLED", "FLAT", "ZIGZAG") var BOTTOM_STYLE = "FILLED" setget set_bottom_style

func get_ecsg_type(): return "ECSGStairs"

func set_steps(val):
	val = clamp(val, 2, 32)
	STEPS = val
	_calc_polygon()

func set_height(val):
	val = clamp(val, 0.1, 8.0)
	HEIGHT = val
	_calc_polygon()

func set_width(val):
	val = clamp(val, 0.1, 4.0)
	WIDTH = val
	$CSGPolygon.depth = val
	$CSGPolygon.transform.origin.x = -(val * 0.5)
	_calc_polygon()

func set_depth(val):
	val = clamp(val, 0.1, 8.0)
	DEPTH = val
	_calc_polygon()

func set_bottom_style(val):
	BOTTOM_STYLE = val
	_calc_polygon()

func _calc_polygon():
	var points = PoolVector2Array()

	var step_size : float = DEPTH / STEPS
	var step_height : float = HEIGHT / STEPS

	if BOTTOM_STYLE == "FILLED":
		points.push_back(Vector2(0.0, 0.0))

		for s in range(STEPS):
			var z1 = s * (step_size)
			var z2 = z1 + step_size
			var y1 = HEIGHT - (s * step_height)
			var y2 = y1 - step_height

			if (s == 0):
				points.push_back(Vector2(z1, y1))

			points.push_back(Vector2(z2, y1))
			points.push_back(Vector2(z2, y2))

	elif BOTTOM_STYLE == "FLAT":
		points.push_back(Vector2(0.0, HEIGHT - step_height))

		for s in range(STEPS):
			var z1 = s * (step_size)
			var z2 = z1 + step_size
			var y1 = HEIGHT - (s * step_height)
			var y2 = y1 - step_height

			if (s == 0):
				points.push_back(Vector2(z1, y1))

			points.push_back(Vector2(z2, y1))
			points.push_back(Vector2(z2, y2))

		points.push_back(Vector2((STEPS - 1) * step_size, 0.0))

	elif BOTTOM_STYLE == "ZIGZAG":
		for s in range(STEPS):
			var z1 = s * (step_size)
			var z2 = z1 + step_size
			var y1 = HEIGHT - (s * step_height)
			var y2 = y1 - step_height

			if (s == 0):
				points.push_back(Vector2(z1, y1))

			points.push_back(Vector2(z2, y1))
			points.push_back(Vector2(z2, y2))

		for s in range(STEPS -2, -1, -1):
			var z = s * (step_size)
			var y1 = HEIGHT - ((s + 1) * step_height)
			var y2 = y1 - step_height

			points.push_back(Vector2(z, y2))
			points.push_back(Vector2(z, y1))



	$CSGPolygon.polygon = points
