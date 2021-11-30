tool
extends EditorPlugin

# Gizmos
const ECSGConeGizmo = preload("res://addons/e_csg_plugin/gizmos/ecsg_cone.gd")
const ECSGStarGizmo = preload("res://addons/e_csg_plugin/gizmos/ecsg_star.gd")
const ECSGWallGizmo = preload("res://addons/e_csg_plugin/gizmos/ecsg_wall.gd")
const ECSGTerrainGizmo = preload("res://addons/e_csg_plugin/gizmos/ecsg_terrain.gd")

# UI Scenes
const CatalogueDockScene = preload("res://addons/e_csg_plugin/interface/catalogue_dock.tscn")

var _ecsgConeGizmo = ECSGConeGizmo.new()
var _ecsgStarGizmo = ECSGStarGizmo.new()
var _ecsgWallGizmo = ECSGWallGizmo.new()
var _ecsgTerrainGizmo = ECSGTerrainGizmo.new()
var _catalogueDock = null

func _enter_tree():
	# autoloads
	add_autoload_singleton("ECSG", "res://addons/e_csg_plugin/ecsg.gd")
	ECSG.plugin = self

	# gizmos
	add_spatial_gizmo_plugin(_ecsgConeGizmo)
	add_spatial_gizmo_plugin(_ecsgStarGizmo)
	add_spatial_gizmo_plugin(_ecsgWallGizmo)
	add_spatial_gizmo_plugin(_ecsgTerrainGizmo)

	# catalogue dock
	_catalogueDock = CatalogueDockScene.instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, _catalogueDock)
	pass


func _exit_tree():
	# cleanup dock
	remove_control_from_docks(_catalogueDock)
	_catalogueDock.free()

	# cleanup gizmos
	remove_spatial_gizmo_plugin(_ecsgTerrainGizmo)
	remove_spatial_gizmo_plugin(_ecsgWallGizmo)
	remove_spatial_gizmo_plugin(_ecsgStarGizmo)
	remove_spatial_gizmo_plugin(_ecsgConeGizmo)

	# cleanup autoloads
	remove_autoload_singleton("ECSG")
	pass

func set_state(state):
	prints(state)

func get_state():
	prints("get_state")
	return { plugin = 'ecsg' }

func create_and_add_ecsg_preset(preset_path):
	var res = ResourceLoader.load(preset_path, "PackedScene")
	if (res == null):
		return
	var instance = res.instance()
	add_ecsg_instance(instance)

func add_ecsg_instance(instance):
	var root3D = get_editor_interface().get_edited_scene_root()
	if (root3D == null):
		push_error("Cannot create instance, please add a spatial or one of its derivative to the scene root first")
		return
	if (instance == null):
		return
	root3D.add_child(instance)
	instance.set_owner(root3D)
	get_editor_interface().get_selection().clear()
	get_editor_interface().get_selection().add_node(instance)