extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Star"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGStar")

func _init():
	._init()

func redraw(gizmo):
	gizmo.clear()
	var spatial = gizmo.get_spatial_node()

	# height edit handle
	var handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(0, spatial))
	gizmo.add_handles(handles, get_material("handle_y", gizmo))

	# inset edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(1, spatial))
	gizmo.add_handles(handles, get_material("handle_square"))

func get_handle_local_position(index, spatial):
	match (index):
		0: return Vector3(0.0, spatial.HEIGHT, 0.0)
		1: return spatial.get_spike_local_point(0)
		_: return Vector3.ZERO

func get_handle_global_position(index, spatial):
	return spatial.to_global(get_handle_local_position(index, spatial))

func get_handle_name(gizmo, index):
	match(index):
		0: return 'Height'
		1: return 'Inset'
		_: return ''

func get_handle_value(gizmo, index):
	var spatial = gizmo.get_spatial_node()
	match (index):
		0: return spatial.HEIGHT
		1: return spatial.INSET
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

	# inset
	if index == 1:
		var val = calc_handle_value(
			spatial.transform.basis.z,
			get_handle_global_position(1, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.INSET = 1.0 - val.length()
