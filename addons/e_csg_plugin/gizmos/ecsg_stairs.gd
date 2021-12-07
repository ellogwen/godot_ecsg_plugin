extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Stairs"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGStairs")

func _init():
	._init()

func redraw(gizmo):
	gizmo.clear()
	var spatial = gizmo.get_spatial_node()


	# width edit handle
	var handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(0, spatial))
	gizmo.add_handles(handles, get_material("handle_x", gizmo))

	# height edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(1, spatial))
	gizmo.add_handles(handles, get_material("handle_y", gizmo))

	# depth edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(2, spatial))
	gizmo.add_handles(handles, get_material("handle_z", gizmo))

	# steps edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(3, spatial))
	gizmo.add_handles(handles, get_material("handle_square", gizmo))


func get_handle_local_position(index, spatial):
	match (index):
		0: return Vector3(spatial.WIDTH * 0.5, spatial.HEIGHT * 0.5, spatial.DEPTH * 0.5)
		1: return Vector3(0.0, spatial.HEIGHT, 0.0)
		2: return Vector3(0.0, 0.0, spatial.DEPTH)
		3: return Vector3(0.0, spatial.HEIGHT * 0.5, spatial.DEPTH * 0.5)
		_: return Vector3.ZERO

func get_handle_name(gizmo, index):
	match(index):
		0: return 'Width'
		1: return 'Height'
		2: return 'Depth'
		3: return 'Steps'
		_: return ''

func get_handle_value(gizmo, index):
	var spatial = gizmo.get_spatial_node()
	match (index):
		0: return spatial.WIDTH
		1: return spatial.HEIGHT
		2: return spatial.DEPTH
		3: return spatial.STEPS
		_: return null

func set_handle(gizmo, index, camera, screen_pos):
	var spatial = gizmo.get_spatial_node()

	# width handle
	if index == 0:
		var val = calc_handle_value(
			spatial.transform.basis.x,
			get_handle_global_position(0, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.WIDTH = val.length() * 2.0

	# height
	if index == 1:
		var val = calc_handle_value(
			spatial.transform.basis.y,
			get_handle_global_position(1, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.HEIGHT = val.length()

	# depth
	if index == 2:
		var val = calc_handle_value(
			spatial.transform.basis.z,
			get_handle_global_position(2, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.DEPTH = val.length()

	# steps
	if index == 3:
		var val = calc_handle_value(
			spatial.transform.basis.z,
			get_handle_global_position(3, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)

		if val != null:
			spatial.STEPS = int(val.length() * 10.0)
