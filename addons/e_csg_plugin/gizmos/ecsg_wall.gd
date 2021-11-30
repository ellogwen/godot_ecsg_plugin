extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Wall"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGWall")

func _init():
	create_handle_material("handle_a")

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

	# length handle
	if index == 0:
		var toAxis = spatial.global_transform.basis.y
		var handle_pos = get_handle_global_position(0, spatial)
		var p = Plane(spatial.global_transform.basis.z, handle_pos.z)
		var intersection = p.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
		if intersection != null:
			var newAxisPos = (intersection - handle_pos).project(toAxis) + handle_pos
			spatial.LENGTH = newAxisPos.y

	# length fw
	if index == 1:
		var toAxis = spatial.global_transform.basis.z
		var handle_pos = get_handle_global_position(1, spatial)
		var p = Plane(spatial.global_transform.basis.x, handle_pos.x)
		var intersection = p.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
		if intersection != null:
			var newAxisPos = (intersection - handle_pos).project(toAxis) + handle_pos
			spatial.LENGTH = newAxisPos.z

	# width handler
	if index == 2:
		var toAxis = spatial.global_transform.basis.x
		var handle_pos = get_handle_global_position(2, spatial)
		var p = Plane(spatial.global_transform.basis.z, handle_pos.z)
		var intersection = p.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
		if intersection != null:
			var newAxisPos = (intersection - handle_pos).project(toAxis) + handle_pos
			spatial.WIDTH = newAxisPos.x

	# segment height handler
	if index > 2:
		var toAxis = spatial.global_transform.basis.y
		var handle_pos = get_handle_global_position(index, spatial)
		var p = Plane(spatial.global_transform.basis.z, handle_pos.z)
		var intersection = p.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
		if intersection != null:
			var newAxisPos = (intersection - handle_pos).project(toAxis) + handle_pos
			spatial.set_top_row_height(index - 3, newAxisPos.y)
