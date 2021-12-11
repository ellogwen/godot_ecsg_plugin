tool
extends "res://addons/e_csg_plugin/core/ecsg_object.gd"

export(int, 1, 100) var COLUMNS = 10 setget set_columns
export(int, 1, 100) var ROWS = 10 setget set_rows
export(float, 0.1, 16.0) var SEGMENT_SIZE = 1.0 setget set_segment_size

func get_ecsg_type(): return "ECSGTerrain"

var _planeMesh = null
var _ecsg_terrain_geometry_storage = []
onready var _csgMesh = $CSGMesh
func get_plane_mesh(): return _planeMesh

func _get_property_list():
	var props = Array()
	props.append({
		name = "_ecsg_terrain_geometry_storage",
		type = TYPE_ARRAY,
		usage = PROPERTY_USAGE_STORAGE,
	})
	return props

func _get(prop):
	match(prop):
		'_ecsg_terrain_geometry_storage':
			return _planeMesh.geometry()

func _set(prop, val):
	match(prop):
		'_ecsg_terrain_geometry_storage':
			_ecsg_terrain_geometry_storage = val
			return true
	return false

func _ready():
	_planeMesh = MeshCreator_Mesh_Mesh.new()
	if (not _ecsg_terrain_geometry_storage.empty()):
		_planeMesh.from_geometry(_ecsg_terrain_geometry_storage)
		prints("[ECSG] Updated mesh vertices from storage:", _ecsg_terrain_geometry_storage.size())
	_update_mesh()

func set_columns(cols):
	cols = clamp(cols, 1, 100)
	COLUMNS = cols
	_build_mesh()
	_update_mesh()

func set_rows(rows):
	rows = clamp(rows, 1, 100)
	ROWS = rows
	_build_mesh()
	_update_mesh()

func set_segment_size(size):
	size = clamp(size, 0.1, 16.0)
	SEGMENT_SIZE = size
	_build_mesh()
	_update_mesh()

func get_face_height(index):
	if (_planeMesh == null):
		return 0.0
	var face = _planeMesh.get_face(index)
	if (face == null):
		return 0.0
	return face.get_centroid().y

func set_face_height(index, height):
	height = clamp(height, -16.0, 16.0)
	if (_planeMesh == null):
		return
	var face = _planeMesh.get_face(index)
	if face == null:
		return
	for vtx in face.get_vertices():
		var v = vtx.get_position()
		vtx.set_position(Vector3(v.x, height, v.z))
	_update_mesh()

func _build_mesh():
	_planeMesh = MeshCreator_Mesh_Mesh.new()

	var width = float(COLUMNS * SEGMENT_SIZE)
	var depth = float(ROWS * SEGMENT_SIZE)
	var cutSize = Vector3(width / float((COLUMNS + 1)), 0.0, depth / float((ROWS + 1)))
	var halfCut = Vector3(cutSize.x / 2.0, cutSize.y / 2.0, cutSize.z / 2.0)
	var halfSize = Vector3(width / 2.0, 0.0, depth / 2.0)

	for x in range(0, COLUMNS + 1):
		for z in range(0, ROWS + 1):
			var a = Vector3(-halfSize.x + (x * cutSize.x), halfSize.y, -halfSize.z + (z * cutSize.z))
			var b = Vector3(-halfSize.x + (x * cutSize.x) + cutSize.x, halfSize.y, -halfSize.z + (z * cutSize.z))
			var c = Vector3(-halfSize.x + (x * cutSize.x) + cutSize.x, halfSize.y, -halfSize.z + (z * cutSize.z) + cutSize.z)
			var d = Vector3(-halfSize.x + (x * cutSize.x), halfSize.y, -halfSize.z + (z * cutSize.z) + cutSize.z)
			_planeMesh.add_face_from_points(PoolVector3Array([a, b, c, d]))
	pass

func _update_mesh():
	if _csgMesh == null:
		return
	var mesh_tools = MeshCreator_MeshTools.new()
	var mesh = mesh_tools.CreateArrayMeshFromMeshCreatorMeshFaces(_planeMesh.get_faces(), _csgMesh.mesh)
	_ecsg_terrain_geometry_storage = _planeMesh.geometry()

func _2d_2_1d(column, row):
	return (row * COLUMNS) + column
