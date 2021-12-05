extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Wall"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGWall")

func _init():
	create_handle_material("handle_a")
	create_material("plane", Color.orange)

func redraw(gizmo):
	gizmo.clear()
	var spatial = gizmo.get_spatial_node()

	var handles = PoolVector3Array()

	# length backward edit handle
	handles.push_back(get_handle_local_position(0, spatial))

	# length forward edit handle
	handles.push_back(get_handle_local_position(1, spatial))

	# width edit handle
	handles.push_back(get_handle_local_position(2, spatial))

	# height edit handles
	var seg_length = spatial.LENGTH / spatial.SEGMENTS
	for p in spatial.get_top_row_points():
		handles.push_back(p)

	gizmo.add_handles(handles, get_material("handle_a", gizmo))

#	var handle_pos: Vector3 = get_handle_local_position(1, spatial)
#	var stG = spatial.global_transform.origin
#	var stL = spatial.transform.origin
#	var sbG = spatial.global_transform.basis
#	var sbL = spatial.transform.basis
#	var p = Plane(
#		spatial.transform.basis.y,
#		handle_pos.y
#	)
	# prints("TO: ", spatial.transform.origin, "TB:", spatial.transform.basis, "HP:", handle_pos, "PC:", p.center())
	# _debug_draw_plane(p, gizmo, 4.0)

func _debug_draw_plane(plane: Plane, gizmo: EditorSpatialGizmo, size = 2.0):
	var spatial = gizmo.get_spatial_node()
	var c: Vector3 = plane.center()
	var x: Vector3 = c.cross(-Vector3.UP)
	var z = x.rotated(plane.normal, PI / 2.0)
	var wh = size * 0.5

	var vertices = PoolVector3Array()
	# A
	vertices.push_back(c + Vector3(wh, 0, -wh))
	vertices.push_back(c + Vector3(-wh, 0, wh))
	vertices.push_back(c + Vector3(-wh, 0, -wh))

	# B
	vertices.push_back(c + Vector3(wh, 0, -wh))
	vertices.push_back(c + Vector3(wh, 0, wh))
	vertices.push_back(c + Vector3(-wh, 0, wh))


	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices

	var arr_mesh = ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	gizmo.add_mesh(arr_mesh, false, null, get_material("plane", gizmo))

	var lines = PoolVector3Array()
	lines.push_back(spatial.to_local(plane.center()))
	lines.push_back(spatial.to_local(plane.center() + (plane.normal * 20)))
	gizmo.add_lines(lines, get_material("plane", gizmo))

func get_handle_local_position(index, spatial):
	match (index):
		0: return Vector3(spatial.WIDTH * 0.5, 0.5, 0.0)
		1: return Vector3(spatial.WIDTH * 0.5, 0.5, spatial.LENGTH)
		2: return Vector3(spatial.WIDTH, 0.5, spatial.LENGTH * 0.5)
	return spatial.get_top_row_point(index - 3)

func get_handle_global_position(index, spatial):
	return spatial.to_global(get_handle_local_position(index, spatial))

func get_handle_name(gizmo, index):
	match(index):
		0: return 'Length Backward'
		1: return 'Length Forward'
		2: return 'Width'
	return "Segment %s" % [ index - 3 ]

func get_handle_value(gizmo, index):
	var spatial = gizmo.get_spatial_node()
	match (index):
		0: return spatial.LENGTH
		1: return spatial.LENGTH
		2: return spatial.WIDTH
	return spatial.get_top_row_point(index - 3).y



func set_handle(gizmo, index, camera, screen_pos):
	var spatial = gizmo.get_spatial_node()

#	# length fw ( this finally works sometimes )
#	if index == 1:
#		var toAxis = spatial.transform.basis.z
#		var g_handle_pos: Vector3 = get_handle_global_position(1, spatial)
#		var look_at_cam = (camera.global_transform.origin - g_handle_pos).normalized()
#		var plane_normal = spatial.transform.basis.y
#		var dot_x = look_at_cam.dot(spatial.transform.basis.x)
#		var dot_x_m = look_at_cam.dot(-spatial.transform.basis.x)
#		var dot_y = look_at_cam.dot(spatial.transform.basis.y)
#		var dot_y_m = look_at_cam.dot(-spatial.transform.basis.y)
##
#
#		if (dot_x > dot_y and dot_x > dot_x_m and dot_x > dot_y_m):
#			prints("Using local X")
#			plane_normal = spatial.transform.basis.x
#		elif (dot_y > dot_x and dot_y > dot_x_m and dot_y > dot_y_m):
#			prints("Using local Y")
#			plane_normal = spatial.transform.basis.y
#		elif (dot_x_m > dot_x and dot_x_m > dot_y and dot_x_m > dot_y_m):
#			prints("Using local X")
#			plane_normal = -spatial.transform.basis.x
#		elif (dot_y_m > dot_x and dot_y_m > dot_y and dot_y_m > dot_x_m):
#			prints("Using local Y")
#			plane_normal = -spatial.transform.basis.y
#
#		var p_obj = Plane(plane_normal, 0.0)
#		var g_intersection = p_obj.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
#		if g_intersection != null:
#			var g_intersection_pro = p_obj.project(g_intersection)
#			var g_newAxisPos = (g_intersection_pro - spatial.global_transform.origin).project(toAxis)
#			prints(g_intersection_pro, g_handle_pos, g_newAxisPos, spatial.global_transform.origin, spatial.transform.origin)
#
#			spatial.LENGTH = (g_newAxisPos).length()

	if index == 1:
		var val = calc_handle_value(
			spatial.transform.basis.z,
			spatial.transform.basis.y,
			spatial.transform.basis.x,
			get_handle_global_position(1, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.LENGTH = val.length()

	# width handler
	if index == 2:
#		var toAxis = spatial.global_transform.basis.x
#		var handle_pos = get_handle_global_position(2, spatial)
#		var p = Plane(spatial.global_transform.basis.z, handle_pos.z)
#		var intersection = p.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
#		if intersection != null:
#			var newAxisPos = (intersection - handle_pos).project(toAxis) + handle_pos
#			spatial.WIDTH = newAxisPos.x
		var val = calc_handle_value(
			spatial.transform.basis.x,
			spatial.transform.basis.y,
			spatial.transform.basis.z,
			get_handle_global_position(2, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.WIDTH = val.length()

	# segment height handler
	if index > 2:
#		var toAxis = spatial.global_transform.basis.y
#		var handle_pos = get_handle_global_position(index, spatial)
#		var p = Plane(spatial.global_transform.basis.z, handle_pos.z)
#		var intersection = p.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
#		if intersection != null:
#			var newAxisPos = (intersection - handle_pos).project(toAxis) + handle_pos
#			spatial.set_top_row_height(index - 3, newAxisPos.y)
		var val = calc_handle_value(
			spatial.transform.basis.y,
			spatial.transform.basis.x,
			spatial.transform.basis.z,
			get_handle_global_position(index, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.set_top_row_height(index - 3, val)
