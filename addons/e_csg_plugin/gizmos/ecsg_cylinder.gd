extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Cylinder"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGCylinder")

func _init():
	._init()

func redraw(gizmo):
	gizmo.clear()
	var spatial = gizmo.get_spatial_node()

	# height edit handle
	var handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(0, spatial))
	gizmo.add_handles(handles, get_material("handle_y", gizmo))

	# radius edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(1, spatial))
	gizmo.add_handles(handles, get_material("handle_x", gizmo))


func get_handle_local_position(index, spatial):
	match (index):
		0: return Vector3(0.0, spatial.HEIGHT, 0.0)
		1: return Vector3(spatial.RADIUS, spatial.HEIGHT * 0.5, 0.0)
		_: return Vector3.ZERO

func get_handle_global_position(index, spatial):
	return spatial.to_global(get_handle_local_position(index, spatial))

func get_handle_name(gizmo, index):
	match(index):
		0: return 'Height'
		1: return 'Radius'
		_: return ''

func get_handle_value(gizmo, index):
	var spatial = gizmo.get_spatial_node()
	match (index):
		0: return spatial.HEIGHT
		1: return spatial.RADIUS
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

	# radius handle
	if index == 1:
		var val = calc_handle_value(
			spatial.transform.basis.x,
			get_handle_global_position(1, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.RADIUS = translate_snapped(val.length())
			spatial.property_list_changed_notify()

	redraw(gizmo)

func commit_handle(gizmo, index, restore, cancel = false):
	var spatial = gizmo.get_spatial_node()
	var undo_redo = get_plugin().get_undo_redo()

	undo_redo.create_action("Cylinder %s" % [ get_handle_name(gizmo, index) ])

	match(index):
		0:
			undo_redo.add_undo_method(spatial, "set_height", restore)
			undo_redo.add_do_method(spatial, "set_height", spatial.HEIGHT)
			undo_redo.commit_action()
		1:
			undo_redo.add_undo_method(spatial, "set_radius", restore)
			undo_redo.add_do_method(spatial, "set_radius", spatial.RADIUS)
			undo_redo.commit_action()
