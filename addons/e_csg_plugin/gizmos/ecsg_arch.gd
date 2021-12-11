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
			spatial.HEIGHT = translate_snapped(val.length())
			spatial.property_list_changed_notify()

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
			spatial.BASE_WIDTH = translate_snapped(val.length() * 2.0)
			spatial.property_list_changed_notify()

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
			spatial.DEPTH = translate_snapped(val.length() * 2.0)
			spatial.property_list_changed_notify()

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
			spatial.property_list_changed_notify()

	redraw(gizmo)

func commit_handle(gizmo, index, restore, cancel = false):
	var spatial = gizmo.get_spatial_node()
	var undo_redo = get_plugin().get_undo_redo()

	undo_redo.create_action("Arch %s" % [ get_handle_name(gizmo, index) ])

	match(index):
		0:
			undo_redo.add_undo_method(spatial, "set_height", restore)
			undo_redo.add_do_method(spatial, "set_height", spatial.HEIGHT)
			undo_redo.commit_action()
		1:
			undo_redo.add_undo_method(spatial, "set_base_width", restore)
			undo_redo.add_do_method(spatial, "set_base_width", spatial.BASE_WIDTH)
			undo_redo.commit_action()
		2:
			undo_redo.add_undo_method(spatial, "set_depth", restore)
			undo_redo.add_do_method(spatial, "set_depth", spatial.DEPTH)
			undo_redo.commit_action()
		3:
			undo_redo.add_undo_method(spatial, "set_thickness", restore)
			undo_redo.add_do_method(spatial, "set_thickness", spatial.THICKNESS)
			undo_redo.commit_action()
