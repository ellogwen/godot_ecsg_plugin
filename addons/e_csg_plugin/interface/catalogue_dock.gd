tool
extends Control

const PresetEntry = preload("res://addons/e_csg_plugin/interface/preset_entry.tscn")

var _presets = {}
var _current_selected_category_key = ""

var _plugin = null
func set_plugin(plugin): _plugin = plugin
func get_plugin(): return _plugin

func _ready():
	$HBoxContainer/RefreshCategories.connect("pressed", self, "on_refresh_categories_button_pressed")
	$HBoxContainer/CategoryOption.connect("item_selected", self, "on_catalogue_option_changed")
	_refresh_catalogue_list()
	_update_categories_dropdown()
	$HBoxContainer/CategoryOption.select(0)
	on_catalogue_option_changed(0)

func on_refresh_categories_button_pressed():
	_refresh_catalogue_list()
	_update_categories_dropdown()

func on_catalogue_option_changed(idx):
	var cat_key = $HBoxContainer/CategoryOption.get_item_metadata(idx)
	_current_selected_category_key = cat_key
	_show_categorie_preset_list(cat_key)
	pass

func _show_categorie_preset_list(cat_key):
	var list = $ScrollContainer/ItemList

	# clear list
	for c in list.get_children():
		list.remove_child(c)
		c.queue_free()

	if not _presets.has(cat_key):
		push_warning("[ECSG] Preset category %s does not exist" % [ cat_key ])
		return

	var pos = 0
	for entry in _presets[cat_key]:
		var meta = { idx = pos, category_key = cat_key, name = entry.name }
		var thumb = null
		if (entry.thumbnail_path):
			thumb = ResourceLoader.load(entry.thumbnail_path, "Texture")

		_add_list_item(pos, entry.name, thumb, entry)

		# has to come after add_list
		if (thumb == null):
			prints("generate preview for", entry.path)
			var prev_gen = get_plugin().get_editor_interface().get_resource_previewer()
			prev_gen.queue_resource_preview(entry.path, self, "on_queue_resource_preview_generated", meta)

		pos = pos + 1
	pass

func on_queue_resource_preview_generated(path, preview, thumbnail, userdata):
	if not preview:
		return
	if not userdata:
		return
	# Still in this category?
	if _current_selected_category_key != userdata.category_key:
		return
	# set entry thumbnail
	for c in $ScrollContainer/ItemList.get_children():
		if (c.get_meta("meta").name == userdata.name):
			c.get_node("Thumbnail").texture = preview
			break
	pass

func _refresh_catalogue_list():
	_presets.clear()

	var dir = Directory.new()
	var catalogue_directories = []

	# collect directories
	if dir.open("res://addons/e_csg_plugin/data/catalogue") == OK:
		dir.list_dir_begin(true, true)
		var d = dir.get_next()
		while d != "":
			if (dir.current_is_dir()):
				if (d.to_lower().is_valid_identifier()):
					catalogue_directories.push_back(d.to_lower())
					prints("[ECSG] Preset category: %s" % [ d.to_lower() ])
				else:
					push_warning("[ECSG] Folder %s may only contain lower score letters, digits and underscores. The first character may not be a digit." % [ d ])
			d = dir.get_next()
		dir.list_dir_end()
	else:
		push_warning("[ECSG] Warning, could not load catalogue data contents. Check file permissions.")

	# collect preset files
	for dir_name in catalogue_directories:
		var preset_scenes = Array()

		if dir.open("res://addons/e_csg_plugin/data/catalogue/%s" % [ dir_name ]) == OK:
			dir.list_dir_begin(true, true)
			var f = dir.get_next()
			while f != "":
				if (dir.current_is_dir()):
					pass
				elif (not (f as String).to_lower().ends_with('.tscn')):
					if (not (f as String).to_lower().ends_with('.png') and not (f as String).to_lower().ends_with('.import')):
						push_warning("[ECSG] Preset file %s does not match file extension (.tscn) or thumbnail png" % [ f ])
				elif (not (f as String).to_lower().begins_with('ecsg_')):
					push_warning("[ECSG] Please prefix file %s with 'ecsg_'" % [ f ])
				else:
					var data = {
						category = dir_name,
						file = f,
						name = (f as String).to_lower().replace('.tscn', '').replace('ecsg_', '').capitalize(),
						path = "res://addons/e_csg_plugin/data/catalogue/%s/%s" % [ dir_name, f],
						thumbnail_path = null
					}

					var thumb_path = "res://addons/e_csg_plugin/data/catalogue/%s/%s" % [ dir_name, f.replace('.tscn', '.png') ]
					if ResourceLoader.exists(thumb_path, "Texture"):
						data.thumbnail_path = thumb_path

					preset_scenes.push_back(data)
					prints("[ECSG]", "Found preset %s/%s" % [ dir_name, f ])
				f = dir.get_next()
			dir.list_dir_end()
		else:
			push_warning("[ECSG] Warning, could not open directory %s. Check that it only consists of lower case letters, digits and underscores. It may NOT start with a digit.")

		_presets[dir_name] = preset_scenes
	pass

func _update_categories_dropdown():
	var co = $HBoxContainer/CategoryOption
	co.clear()
	var keys_sorted = _presets.keys()
	keys_sorted.sort()
	for key in keys_sorted:
		co.add_item((key as String).capitalize())
		co.set_item_metadata(co.get_item_count() - 1, key)

func on_preset_add_button_pressed(meta):
	get_plugin().create_and_add_ecsg_preset(meta.path)

func _add_list_item(idx, name, thumbnail, meta):
	var entry = PresetEntry.instance()
	entry.name = "entry_%s" % [ idx ]
	entry.get_node("Labels/Name").text = name
	entry.get_node("Thumbnail").texture = thumbnail
	entry.get_node("AddButton").connect("pressed", self, "on_preset_add_button_pressed", [ meta ])
	entry.set_meta("meta", meta)
	$ScrollContainer/ItemList.add_child(entry)
