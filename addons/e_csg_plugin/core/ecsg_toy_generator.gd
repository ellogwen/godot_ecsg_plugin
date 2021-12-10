tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(float, 0.1, 4.0, 0.05) var BODY_HEIGHT = 0.5 setget set_body_height
export(int, 1, 8) var COLUMNS = 1 setget set_columns
export(int, 1, 8) var ROWS = 1 setget set_rows

func set_body_height(val):
	val = clamp(val, 0.1, 4.0)
	BODY_HEIGHT = val
	_generate_shape()
	property_list_changed_notify()

func set_columns(val):
	val = clamp(val, 1, 8)
	COLUMNS = val
	_generate_shape()
	property_list_changed_notify()

func set_rows(val):
	val = clamp(val, 1, 8)
	ROWS = val
	_generate_shape()
	property_list_changed_notify()

func _generate_shape():
	for c in get_children():
		remove_child(c)
		c.queue_free()

	var body = CSGBox.new()
	body.height = BODY_HEIGHT
	body.width = COLUMNS * 0.5
	body.depth = ROWS * 0.5
	body.name = "Body"
	add_child(body)
	body.set_owner(get_owner())
	body.transform.origin.y = BODY_HEIGHT * 0.5

	for column in range(COLUMNS):
		for row in range(ROWS):
			var dot = CSGCylinder.new()
			dot.radius = 0.15
			dot.height = 0.1
			dot.sides = 24
			dot.smooth_faces = false
			dot.name = "Dot"
			add_child(dot)
			dot.set_owner(get_owner())
			dot.transform.origin = Vector3(
				(column * 0.5) - (body.width * 0.5) + 0.25,
				BODY_HEIGHT + (dot.height * 0.5) + 0.01, # prevent csg to go crazy
				(row * 0.5) - (body.depth * 0.5) + 0.25
			)


