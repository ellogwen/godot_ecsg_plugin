class_name MeshCreator_MeshTools
extends Reference


func CreateArrayMeshFromMeshCreatorMeshFaces(facesArray, mesh = null, material = null) -> ArrayMesh:
	var arrays = Array()
	arrays.resize(Mesh.ARRAY_MAX)

	var normal_array = PoolVector3Array()
	var uv_array = PoolVector2Array()
	var vertex_array = PoolVector3Array()
	var index_array = PoolIntArray()
	var facesSize = facesArray.size()

	for i in range(0, facesSize):
		var face = facesArray[i]
		face.refresh() # makes sure to work with up to date tris, edges and normals
		for tri in face.get_triangles():
			var edge_ab: float = tri.get_side_length(0)
			var edge_bc: float = tri.get_side_length(1)
			var edge_ca: float = tri.get_side_length(2)
			var centroid: Vector3 = tri.get_center()
			var N: Vector3 = tri.get_normal().abs()
			var Auv = Vector2.ZERO
			var Buv = Vector2.ZERO
			var Cuv = Vector2.ZERO

			if (N.x > N.y and N.x > N.z):
				Auv = Vector2(tri.get_a().z + 0.5, tri.get_a().y + 0.5)
				Buv = Vector2(tri.get_b().z + 0.5, tri.get_b().y + 0.5)
				Cuv = Vector2(tri.get_c().z + 0.5, tri.get_c().y + 0.5)
			elif (N.y > N.x and N.y > N.z):
				Auv = Vector2(tri.get_a().x + 0.5, tri.get_a().z + 0.5)
				Buv = Vector2(tri.get_b().x + 0.5, tri.get_b().z + 0.5)
				Cuv = Vector2(tri.get_c().x + 0.5, tri.get_c().z + 0.5)
			elif (N.z > N.x and N.z > N.y):
				Auv = Vector2(tri.get_a().x + 0.5, tri.get_a().y + 0.5)
				Buv = Vector2(tri.get_b().x + 0.5, tri.get_b().y + 0.5)
				Cuv = Vector2(tri.get_c().x + 0.5, tri.get_c().y + 0.5)

			uv_array.append(Auv)
			normal_array.append(-tri.get_normal())
			vertex_array.append(tri.get_a())
			uv_array.append(Buv)
			normal_array.append(-tri.get_normal())
			vertex_array.append(tri.get_b())
			uv_array.append(Cuv)
			normal_array.append(-tri.get_normal())
			vertex_array.append(tri.get_c())
			pass
		pass

	arrays[Mesh.ARRAY_VERTEX] = vertex_array
	arrays[Mesh.ARRAY_NORMAL] = normal_array
	arrays[Mesh.ARRAY_TEX_UV] = uv_array

	# empty mesh
	if (mesh != null):
		for s in range(mesh.get_surface_count()):
			mesh.surface_remove(s)
	else:
		mesh = ArrayMesh.new()

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh.surface_set_material(0, material)
	return mesh

