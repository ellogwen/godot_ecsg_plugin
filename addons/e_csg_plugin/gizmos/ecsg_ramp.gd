extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Ramp"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGRamp")

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


func get_handle_local_position(index, spatial):
	match (index):
		0: return Vector3(spatial.WIDTH * 0.5, spatial.HEIGHT * 0.5, spatial.DEPTH * 0.5)
		1: return Vector3(0.0, spatial.HEIGHT, 0.0)
		2: return Vector3(0.0, 0.0, spatial.DEPTH)
		_: return Vector3.ZERO

func get_handle_name(gizmo, index):
	match(index):
		0: return 'Width'
		1: return 'Height'
		2: return 'Depth'
		_: return ''

func get_handle_value(gizmo, index):
	var spatial = gizmo.get_spatial_node()
	match (index):
		0: return spatial.WIDTH
		1: return spatial.HEIGHT
		2: return spatial.DEPTH
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
			spatial.WIDTH = translate_snapped(val.length() * 2.0)
			spatial.property_list_changed_notify()

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
			spatial.HEIGHT = translate_snapped(val.length())
			spatial.property_list_changed_notify()

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
			spatial.DEPTH = translate_snapped(val.length())

	redraw(gizmo)

func commit_handle(gizmo, index, restore, cancel = false):
	var spatial = gizmo.get_spatial_node()
	var undo_redo = get_plugin().get_undo_redo()

	undo_redo.create_action("Ramp %s" % [ get_handle_name(gizmo, index) ])

	match(index):
		0:
			undo_redo.add_undo_method(spatial, "set_width", restore)
			undo_redo.add_do_method(spatial, "set_width", spatial.WIDTH)
			undo_redo.commit_action()
		1:
			undo_redo.add_undo_method(spatial, "set_height", restore)
			undo_redo.add_do_method(spatial, "set_height", spatial.HEIGHT)
			undo_redo.commit_action()
		2:
			undo_redo.add_undo_method(spatial, "set_depth", restore)
			undo_redo.add_do_method(spatial, "set_depth", spatial.DEPTH)
			undo_redo.commit_action()
