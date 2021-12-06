extends EditorSpatialGizmoPlugin

func get_name(): return "ECSG Object"

func is_ecsg_type(spatial, ecsg_type):
	return (
		spatial.has_method("is_ecsg")
		and spatial.is_ecsg()
		and spatial.has_method("get_ecsg_type")
		and spatial.get_ecsg_type() == ecsg_type
	)

func calc_handle_value(
	to_axis: Vector3,
	g_handle_pos: Vector3,
	camera,
	screen_pos: Vector2,
	origin: Vector3):
		var camera_basis: Basis = camera.get_transform().basis
		var p_obj := Plane(g_handle_pos, g_handle_pos + camera_basis.x, g_handle_pos + camera_basis.y)
		var g_intersection = p_obj.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
		if g_intersection != null:
			var g_intersection_pro = p_obj.project(g_intersection)
			var g_newAxisPos = (g_intersection_pro - origin).project(to_axis)

			return (g_newAxisPos)

		return null
