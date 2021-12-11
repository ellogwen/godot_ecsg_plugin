tool
extends CSGCombiner
class_name ECSGObject

const ECSG = preload("res://addons/e_csg_plugin/ecsg.tres")
const _ecsg_enums_material_theme_options = "Prototype,Palette,Custom"
const _ecsg_enums_palette_options = "Black,White,Dark Blue,Dark Brown,Dark Gray,Dark Green,Dark Red,Light Blue,Light Brown,Light Gray,Light Green,Light Red,Orange,Pink,Skin,Yellow"
const _ecsg_enums_prototype_options = "Dark,Light,Green,Red,Purple,Orange"

var _ecsg_theme = "Prototype"
var _ecsg_palette = "White"
var _ecsg_prototype = "Light"
var _ecsg_custom_mat = null

func is_ecsg(): return true
func get_ecsg_type(): return "ECSGObject" # override me for custom gizmos

func _init():
	ECSG.setup()

func _ready():
	_update_material()

func _get_property_list():
	var props = Array()

	props.append({
		name = "_ecsg_edt_theme",
		type = TYPE_STRING,
		usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,
		hint = PROPERTY_HINT_ENUM,
		hint_string = _ecsg_enums_material_theme_options
	})

	if (_ecsg_theme == "Prototype"):
		props.append({
			name = "_ecsg_edt_prototype",
			type = TYPE_STRING,
			usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,
			hint = PROPERTY_HINT_ENUM,
			hint_string = _ecsg_enums_prototype_options
		})

	if (_ecsg_theme == "Palette"):
		props.append({
			name = "_ecsg_edt_palette",
			type = TYPE_STRING,
			usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,
			hint = PROPERTY_HINT_ENUM,
			hint_string = _ecsg_enums_palette_options
		})

	return props

func _set(prop, val):
	match (prop):
		"_ecsg_edt_theme":
			self._ecsg_theme = val
			property_list_changed_notify()
			_update_material()
			return true
		"_ecsg_edt_palette":
			self._ecsg_palette = val
			_update_material()
			return true
		"_ecsg_edt_prototype":
			self._ecsg_prototype = val
			_update_material()
			return true
		"_ecsg_edt_custom_mat":
			self._ecsg_custom_mat = val
			_update_material()
			return true
	return false

func _get(prop):
	match (prop):
		"_ecsg_edt_theme":
			return self._ecsg_theme
		"_ecsg_edt_palette":
			return self._ecsg_palette
		"_ecsg_edt_prototype":
			return self._ecsg_prototype
		"_ecsg_edt_custom_mat":
			return self._ecsg_custom_mat
	return null

func _update_material():
	# prints("updating materials")
	match (_ecsg_theme):
		"Prototype":
			match (_ecsg_prototype):
				"Dark":
					material_override = ECSG.MAT_PROTO_DARK
				"Light":
					material_override = ECSG.MAT_PROTO_LIGHT
				"Green":
					material_override = ECSG.MAT_PROTO_GREEN
				"Orange":
					material_override = ECSG.MAT_PROTO_ORANGE
				"Purple":
					material_override = ECSG.MAT_PROTO_PURPLE
				"Red":
					material_override = ECSG.MAT_PROTO_RED
		"Palette":
			var color_key = _ecsg_palette.replace(" ", "_").to_lower()
			if ECSG.MATS_PALETTE.has(color_key):
				material_override = ECSG.MATS_PALETTE[color_key]
		_:
			material_override = ECSG.DEFAULT_MATERIAL
	pass
