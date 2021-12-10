extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Wall"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGWall")

func _init():
	._init()
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

	gizmo.add_handles(handles, get_material("handle_z"))

	# width edit handle
	handles = PoolVector3Array()
	handles.push_back(get_handle_local_position(2, spatial))
	gizmo.add_handles(handles, get_material("handle_x"))

	# height edit handles
	handles = PoolVector3Array()
	var seg_length = spatial.LENGTH / spatial.SEGMENTS
	for p in spatial.get_top_row_points():
		handles.push_back(p)

	gizmo.add_handles(handles, get_material("handle_square_y", gizmo))

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

	if index == 1:
		var val = calc_handle_value(
			spatial.transform.basis.z,
			get_handle_global_position(1, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.LENGTH = val.length()
			spatial.property_list_changed_notify()

	# width handler
	if index == 2:
		var val = calc_handle_value(
			spatial.transform.basis.x,
			get_handle_global_position(2, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.WIDTH = val.length()
			spatial.property_list_changed_notify()

	# segment height handler
	if index > 2:
		var val = calc_handle_value(
			spatial.transform.basis.y,
			get_handle_global_position(index, spatial),
			camera,
			screen_pos,
			spatial.global_transform.origin
		)
		if val != null:
			spatial.set_top_row_height(index - 3, val.length())
			spatial.property_list_changed_notify()
