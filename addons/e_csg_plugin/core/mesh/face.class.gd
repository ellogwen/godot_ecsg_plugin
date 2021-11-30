# namspace MeshCreator_Mesh
class_name MeshCreator_Mesh_Face
extends Reference

# typeof Array<MeshCreator_Mesh_Triangle>
var _tris: Array = Array()
# typeof Array<MeshCreator_Mesh_Vertex>
var _vertices: Array = Array()
var _edges: Array = Array()

var _normal: Vector3
var _centroid: Vector3 = Vector3.ZERO
var _meshIndex: int = -1

func _init(verts: Array = Array()) -> void:
	for v in verts:
		_vertices.push_back(v)
	_edges.clear()
	_edges.resize(_vertices.size())
	_triangulate()
	_calc_normal()
	_calc_centroid()
	pass

func refresh():
	_triangulate()
	_calc_normal()
	_calc_centroid()

func get_normal() -> Vector3: return _normal
func get_centroid() -> Vector3:	return _centroid

func get_mesh_index() -> int:
	return _meshIndex
	pass

func set_mesh_index(idx: int) -> void:
	_meshIndex = idx
	pass

#func from_points(points: PoolVector3Array) -> void:
#	_vertices.clear()
#	for pt in points:
#		_vertices.push_back(MeshCreator_Mesh_Vertex.new(pt))
#	_triangulate()
#	_calc_normal()
#	_calc_centroid()

func from_verts(verts: Array) -> void:
	_vertices.clear()
	for vtx in verts:
		_vertices.push_back(vtx)
	_edges.clear()
	_edges.resize(_vertices.size())
	_triangulate()
	_calc_normal()
	_calc_centroid()

func get_triangles() -> Array:
	return _tris

# @todo this does only work with convex!
func _triangulate() -> bool:
	var vertCount = _vertices.size()
	if (vertCount < 3):
		return false
	_tris.clear()
	for i in range(2, vertCount):
		var c = _vertices[i].get_position()
		var b = _vertices[i - 1].get_position()
		var a = _vertices[0].get_position()
		var tri = MeshCreator_Mesh_Triangle.new(a, b, c)
		_tris.push_back(tri)
	return true

func _calc_normal() -> void:
	var trisCount = _tris.size()
	if (trisCount < 1):
		return

	_normal = Vector3.ZERO
	for tri in _tris:
		_normal += tri.get_normal()
	_normal /= trisCount
	_normal = _normal.normalized()
	pass

func _calc_centroid() -> void:
	var vertCount = _vertices.size()
	if (vertCount < 3):
		return

	var vecSum = Vector3.ZERO
	for v in _vertices:
		vecSum += v.get_position()

	_centroid = vecSum / vertCount
	pass

func set_point_at_index(index: int, p: Vector3) -> void:
	_vertices[index].set_position(p)
	_triangulate()
	_calc_normal()
	_calc_centroid()

func get_edge_length(fromIndex: int) -> float:
	var vertCount = _vertices.size()
	if (fromIndex < 0):
		return 0.0
	if (fromIndex >= vertCount):
		return 0.0

	var toIndex = fromIndex + 1
	if (fromIndex == vertCount - 1):
		toIndex = 0

	var a = _vertices[fromIndex].get_position()
	var b = _vertices[toIndex].get_position()

	return (b - a).length()

func get_vertex(index: int) -> MeshCreator_Mesh_Vertex:
	return _vertices[index]

func get_vertices() -> Array:
	return _vertices

func get_points() -> PoolVector3Array:
	var result = PoolVector3Array()
	for vtx in get_vertices():
		result.push_back(vtx.get_position())
	return result

func has_vertex(vertex: MeshCreator_Mesh_Vertex) -> bool:
	return has_vertex_position(vertex.get_position())

func has_vertex_position(position: Vector3) -> bool:
	for v in _vertices:
		if (position == v.get_position()):
			return true
	return false

func get_edge_index(a, b) -> int:
	var vertexCount = _vertices.size()
	for i in range(0, vertexCount):
		var endIndex = i + 1
		if (i == vertexCount - 1):
			endIndex = 0
		var ea = _vertices[i].get_position()
		var eb = _vertices[endIndex].get_position()

		if ((a == ea and b == eb) or (a == eb and b == ea)):
			return i

	return -1

# @todo check out of bounds
func get_edge_start(index) -> Vector3:
	return _vertices[index].get_position()

# @todo check out of bounds
func get_edge_end(index) -> Vector3:
	return _vertices[(index + 1) % get_vertex_count()].get_position()

func has_edge(a, b):
	return (get_edge_index(a, b) >= 0)

func get_edges():
	return _edges

func get_vertex_index(position: Vector3) -> int:
	for i in range(0, _vertices.size()):
		if _vertices[i].get_position() == position:
			return i
	return -1

func equals(otherFace: MeshCreator_Mesh_Face) -> bool:
	for vtx in otherFace.get_vertices():
		if (has_vertex(vtx) == false):
			return false
	return true

func get_vertex_count() -> int:
	return _vertices.size()

func set_edge(edgeIndex, edgeId):
	_edges[edgeIndex] = edgeId

func get_edge_normal(edgeIndex):
	var a = get_edge_start(edgeIndex)
	var b = get_edge_end(edgeIndex)
	var center = a + ((b - a) * 0.5)
	return (center - get_centroid()).normalized()

func get_edge_center(edgeIndex):
	var a = get_edge_start(edgeIndex)
	var b = get_edge_end(edgeIndex)
	var ab = (b - a)
	return a + (ab * 0.5)

func get_axis_x():
	return get_edge_normal(0)

func get_axis_y():
	return (get_axis_x().cross(get_axis_z())).normalized()

func get_axis_z():
	return get_normal()

# clone leads to all sorts of problems, remove for now
#func clone(newId = -1) -> MeshCreator_Mesh_Face:
#	var pts = PoolVector3Array()
#	for vtx in _vertices.size():
#		pts.push_back(vtx.get_position())
#	var f = get_script().new(pts)
#	return f
