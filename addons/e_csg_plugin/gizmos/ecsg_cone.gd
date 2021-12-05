extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Cone"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGCone")

func _init():
	create_handle_material("handle_a")

func redraw(gizmo):
	gizmo.clear()
	var spatial = gizmo.get_spatial_node()

	var handles = PoolVector3Array()

	# height edit handle
	handles.push_back(get_handle_local_position(0, spatial))

	# flatter edit handle
	if (spatial.FLAT_TOP):
		handles.push_back(get_handle_local_position(1, spatial))

	gizmo.add_handles(handles, get_material("handle_a", gizmo))

func get_handle_local_position(index, spatial):
	match (index):
		0: return Vector3(0.0, spatial.HEIGHT, 0.0)
		1: return Vector3(0.0, spatial.HEIGHT - spatial.FLAT_TOP_OFFSET, 0.0)
		_: return Vector3.ZERO

func get_handle_global_position(index, spatial):
	return spatial.to_global(get_handle_local_position(index, spatial))

func get_handle_name(gizmo, index):
	match(index):
		0: return 'Height'
		1: return 'Flattening'
		_: return ''

func get_handle_value(gizmo, index):
	var spatial = gizmo.get_spatial_node()
	match (index):
		0: return spatial.HEIGHT
		1: return spatial.FLAT_TOP_OFFSET
		_: return null

func set_handle(gizmo, index, camera, screen_pos):
	var spatial = gizmo.get_spatial_node()

	# height handle
	if index == 0:
#		var toAxis = spatial.global_transform.basis.y
#		var handle_pos = get_handle_global_position(0, spatial)
#		var p = Plane(spatial.global_transform.basis.z, handle_pos.z)
#		var intersection = p.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
#		if intersection != null:
#			var newAxisPos = (intersection - handle_pos).project(toAxis) + handle_pos
#			spatial.HEIGHT = newAxisPos.y
		var val = calc_handle_value(
			spatial.transform.basis.y,
			spatial.transform.basis.x,
			spatial.transform.basis.z,
			get_handle_global_position(0, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.HEIGHT = val.length()

	# flatter
	if index == 1:
#		var toAxis = spatial.global_transform.basis.y
#		var handle_pos = get_handle_global_position(1, spatial)
#		var p = Plane(spatial.global_transform.basis.z, handle_pos.z)
#		var intersection = p.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
#		if intersection != null:
#			var newAxisPos = (intersection - handle_pos).project(toAxis) + handle_pos
#			spatial.FLAT_TOP_OFFSET = 1.0 - newAxisPos.y
		var val = calc_handle_value(
			spatial.transform.basis.y,
			spatial.transform.basis.x,
			spatial.transform.basis.z,
			get_handle_global_position(1, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.FLAT_TOP_OFFSET = val.length()
