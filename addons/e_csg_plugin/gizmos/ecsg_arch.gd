extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Arch"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGArch")

func _init():
	._init()

func redraw(gizmo):
	gizmo.clear()
	var spatial = gizmo.get_spatial_node()


	# height edit handle
	var handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(0, spatial))
	gizmo.add_handles(handles, get_material("handle_y", gizmo))

	# width edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(1, spatial))
	gizmo.add_handles(handles, get_material("handle_x", gizmo))

	# depth edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(2, spatial))
	gizmo.add_handles(handles, get_material("handle_z", gizmo))

	# thickness edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(3, spatial))
	gizmo.add_handles(handles, get_material("handle_square", gizmo))


func get_handle_local_position(index, spatial):
	match (index):
		0: return Vector3(0.0, spatial.HEIGHT, 0.0)
		1: return Vector3(spatial.BASE_WIDTH * 0.5, 0.0, 0.0)
		2: return Vector3(0.0, spatial.HEIGHT * 0.5, spatial.DEPTH * 0.5)
		3: return Vector3(spatial.BASE_WIDTH * 0.5 - spatial.THICKNESS * 0.25, 0.0, 0.0)
		_: return Vector3.ZERO

func get_handle_global_position(index, spatial):
	return spatial.to_global(get_handle_local_position(index, spatial))

func get_handle_name(gizmo, index):
	match(index):
		0: return 'Height'
		1: return 'Width'
		2: return 'Depth'
		3: return 'Thickness'
		_: return ''

func get_handle_value(gizmo, index):
	var spatial = gizmo.get_spatial_node()
	match (index):
		0: return spatial.HEIGHT
		1: return spatial.BASE_WIDTH
		2: return spatial.DEPTH
		3: return spatial.THICKNESS
		_: return null

func set_handle(gizmo, index, camera, screen_pos):
	var spatial = gizmo.get_spatial_node()

	# height handle
	if index == 0:
		var val = calc_handle_value(
			spatial.transform.basis.y,
			get_handle_global_position(0, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.HEIGHT = val.length()

	# width handle
	if index == 1:
		var val = calc_handle_value(
			spatial.transform.basis.x,
			get_handle_global_position(1, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.BASE_WIDTH = val.length() * 2.0

	# depth handle
	if index == 2:
		var val = calc_handle_value(
			spatial.transform.basis.z,
			get_handle_global_position(2, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.DEPTH = val.length() * 2.0

	# thickness handle
	if index == 3:
		var val = calc_handle_value(
			spatial.transform.basis.x,
			get_handle_global_position(3, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.THICKNESS = 1.0 - val.length()
