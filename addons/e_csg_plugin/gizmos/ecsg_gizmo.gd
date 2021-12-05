extends EditorSpatialGizmoPlugin

func get_name(): return "ECSG Object"

func is_ecsg_type(spatial, ecsg_type):
	return (
		spatial.has_method("is_ecsg")
		and spatial.is_ecsg()
		and spatial.has_method("get_ecsg_type")
		and spatial.get_ecsg_type() == ecsg_type
	)

func calc_handle_value(to_axis: Vector3,
	pick_plane_normal_a: Vector3,
	pick_plane_normal_b: Vector3,
	g_handle_pos: Vector3,
	camera,
	screen_pos: Vector2,
	origin: Vector3):
		var look_at_cam = (camera.global_transform.origin - g_handle_pos).normalized()
		var plane_normal = pick_plane_normal_a
		var dot_x = look_at_cam.dot(pick_plane_normal_a)
		var dot_x_m = look_at_cam.dot(-pick_plane_normal_a)
		var dot_y = look_at_cam.dot(pick_plane_normal_b)
		var dot_y_m = look_at_cam.dot(-pick_plane_normal_b)
		if (dot_x > dot_y and dot_x > dot_x_m and dot_x > dot_y_m):
			plane_normal = pick_plane_normal_a
		elif (dot_y > dot_x and dot_y > dot_x_m and dot_y > dot_y_m):
			plane_normal = pick_plane_normal_b
		elif (dot_x_m > dot_x and dot_x_m > dot_y and dot_x_m > dot_y_m):
			plane_normal = -pick_plane_normal_a
		elif (dot_y_m > dot_x and dot_y_m > dot_y and dot_y_m > dot_x_m):
			plane_normal = -pick_plane_normal_b

		var p_obj = Plane(plane_normal, 0.0)
		var g_intersection = p_obj.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
		if g_intersection != null:
			var g_intersection_pro = p_obj.project(g_intersection)
			var g_newAxisPos = (g_intersection_pro - origin).project(to_axis)

			return (g_newAxisPos)

		return null
