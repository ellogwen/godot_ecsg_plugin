tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(bool) var CUT_XZ = false setget set_cut_xz
export(bool) var CUT_YZ = false setget set_cut_yz
export(bool) var CUT_XY = false setget set_cut_xy

func get_ecsg_type(): return "ECSGSphere"

func set_cut_xz(val):
	CUT_XZ = val
	$CSGSphere/CutXZ.visible = val
	property_list_changed_notify()

func set_cut_yz(val):
	CUT_YZ = val
	$CSGSphere/CutYZ.visible = val
	property_list_changed_notify()

func set_cut_xy(val):
	CUT_XY = val
	$CSGSphere/CutXY.visible = val
	property_list_changed_notify()
