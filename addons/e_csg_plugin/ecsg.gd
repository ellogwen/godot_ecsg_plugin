tool
extends Resource

const DEFAULT_MATERIAL = preload("res://addons/e_csg_plugin/materials/prototype_white.tres")
const PROTOTYPE_MATERIAL = preload("res://addons/e_csg_plugin/materials/prototype.material.tres")
const PALETTE_MATERIAL = preload("res://addons/e_csg_plugin/materials/palette.material.tres")

# PICO-8 Colors
const PALETTE_COLORS = {
	black = Color("#000000"),
	white = Color("#FFF1E8"),
	dark_blue = Color("#1D2B53"),
	dark_red = Color("#7E2553"),
	dark_gray = Color("#83769C"),
	dark_green = Color("#008751"),
	dark_brown = Color("#5F574F"),
	light_blue = Color("#29ADFF"),
	light_brown = Color("#AB5236"),
	light_gray = Color("#C2C3C7"),
	light_green = Color("#00E436"),
	light_red = Color("#FF004D"),
	orange = Color("#FFA300"),
	pink = Color("#FF77A8"),
	skin = Color("#FFCCAA"),
	yellow = Color("#FFEC27"),
}

var MAT_PROTO_DARK = null
var MAT_PROTO_GREEN = null
var MAT_PROTO_LIGHT = null
var MAT_PROTO_ORANGE = null
var MAT_PROTO_PURPLE = null
var MAT_PROTO_RED = null

var MATS_PALETTE = {}

# var plugin = null
# func get_plugin(): return plugin

# func get_editor_interface() -> EditorInterface:
#	return plugin.get_editor_interface()

var _materials_created = false
func setup():
	if (_materials_created):
		return
	prints("[ECSG]", "Creating material cache")
	# prototype material
	MAT_PROTO_DARK = PROTOTYPE_MATERIAL.duplicate()
	MAT_PROTO_DARK.albedo_texture = preload("res://addons/e_csg_plugin/assets/textures/kenney_prototype/Dark/texture_13.png")
	MAT_PROTO_GREEN = PROTOTYPE_MATERIAL.duplicate()
	MAT_PROTO_GREEN.albedo_texture = preload("res://addons/e_csg_plugin/assets/textures/kenney_prototype/Green/texture_01.png")
	MAT_PROTO_LIGHT = PROTOTYPE_MATERIAL.duplicate()
	MAT_PROTO_LIGHT.albedo_texture = preload("res://addons/e_csg_plugin/assets/textures/kenney_prototype/Light/texture_07.png")
	MAT_PROTO_ORANGE = PROTOTYPE_MATERIAL.duplicate()
	MAT_PROTO_ORANGE.albedo_texture = preload("res://addons/e_csg_plugin/assets/textures/kenney_prototype/Orange/texture_01.png")
	MAT_PROTO_PURPLE = PROTOTYPE_MATERIAL.duplicate()
	MAT_PROTO_PURPLE.albedo_texture = preload("res://addons/e_csg_plugin/assets/textures/kenney_prototype/Purple/texture_01.png")
	MAT_PROTO_RED = PROTOTYPE_MATERIAL.duplicate()
	MAT_PROTO_RED.albedo_texture = preload("res://addons/e_csg_plugin/assets/textures/kenney_prototype/Red/texture_01.png")

	# palette materials
	for color in PALETTE_COLORS.keys():
		var mat = PALETTE_MATERIAL.duplicate()
		mat.albedo_color = PALETTE_COLORS[color]
		MATS_PALETTE[color] = mat

	_materials_created = true
