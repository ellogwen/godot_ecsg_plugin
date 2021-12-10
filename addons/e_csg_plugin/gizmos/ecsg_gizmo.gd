extends EditorSpatialGizmoPlugin

const handle_tex = preload("res://addons/e_csg_plugin/assets/textures/gizmos/handle_n.png")
const handle_x_tex = preload("res://addons/e_csg_plugin/assets/textures/gizmos/handle_x.png")
const handle_y_tex = preload("res://addons/e_csg_plugin/assets/textures/gizmos/handle_y.png")
const handle_z_tex = preload("res://addons/e_csg_plugin/assets/textures/gizmos/handle_z.png")
const handle_square_tex = preload("res://addons/e_csg_plugin/assets/textures/gizmos/handle_square.png")
const handle_square_x_tex = preload("res://addons/e_csg_plugin/assets/textures/gizmos/handle_x_square.png")
const handle_square_y_tex = preload("res://addons/e_csg_plugin/assets/textures/gizmos/handle_y_square.png")
const handle_square_z_tex = preload("res://addons/e_csg_plugin/assets/textures/gizmos/handle_z_square.png")

var _plugin = null

func get_name(): return "ECSG Object"
func get_plugin(): return _plugin
func set_plugin(plugin): _plugin = plugin

func is_ecsg_type(spatial, ecsg_type):
	return (
		spatial.has_method("is_ecsg")
		and spatial.is_ecsg()
		and spatial.has_method("get_ecsg_type")
		and spatial.get_ecsg_type() == ecsg_type
	)

func _init():
	create_handle_material("default", false, handle_tex)
	create_handle_material("handle_x", false, handle_x_tex)
	create_handle_material("handle_y", false, handle_y_tex)
	create_handle_material("handle_z", false, handle_z_tex)
	create_handle_material("handle_square", false, handle_square_tex)
	create_handle_material("handle_square_x", false, handle_square_x_tex)
	create_handle_material("handle_square_y", false, handle_square_y_tex)
	create_handle_material("handle_square_z", false, handle_square_z_tex)

func get_handle_local_position(index, spatial):
	return Vector3.ZERO

func get_handle_global_position(index, spatial):
	return spatial.to_global(get_handle_local_position(index, spatial))

func calc_handle_value(
	to_axis: Vector3,
	g_handle_pos: Vector3,
	camera,
	screen_pos: Vector2,
	origin: Vector3):
		var camera_basis: Basis = camera.get_transform().basis
		var p_obj := Plane(g_handle_pos, g_handle_pos + camera_basis.x, g_handle_pos + camera_basis.y)
		var g_intersection = p_obj.intersects_ray(camera.project_ray_origin(screen_pos), camera.project_ray_normal(screen_pos))
		if g_intersection != null:
			var g_intersection_pro = p_obj.project(g_intersection)
			var g_newAxisPos = (g_intersection_pro - origin).project(to_axis)

			return (g_newAxisPos)

		return null
