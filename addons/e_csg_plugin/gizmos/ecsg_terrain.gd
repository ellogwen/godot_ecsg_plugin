extends "res://addons/e_csg_plugin/gizmos/ecsg_gizmo.gd"

func get_name(): return "ECSG Terrain"

func has_gizmo(spatial):
	return is_ecsg_type(spatial, "ECSGTerrain")

func _init():
	._init()

func redraw(gizmo):
	gizmo.clear()
	var spatial = gizmo.get_spatial_node()

	var handles = PoolVector3Array()

	# height edit handles
	for face in spatial.get_plane_mesh().get_faces():
		handles.push_back(face.get_centroid())

	gizmo.add_handles(handles, get_material("handle_square_y", gizmo))

func get_handle_local_position(index, spatial):
	return spatial.get_plane_mesh().get_face(index).get_centroid()

func get_handle_global_position(index, spatial):
	return spatial.to_global(get_handle_local_position(index, spatial))

func get_handle_name(gizmo, index):
	return "Face %s" % [ index ]

func get_handle_value(gizmo, index):
	var spatial = gizmo.get_spatial_node()
	return spatial.get_face_height(index)

func set_handle(gizmo, index, camera, screen_pos):
	var spatial = gizmo.get_spatial_node()

	# height handle
	var val = calc_handle_value(
		spatial.transform.basis.y,
		get_handle_global_position(index, spatial),
		camera,
		screen_pos,
		spatial.global_transform.origin
		)
	if val != null:
		spatial.set_face_height(index, val.y)
