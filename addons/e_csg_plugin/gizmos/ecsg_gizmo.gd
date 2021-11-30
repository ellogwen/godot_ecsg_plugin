extends EditorSpatialGizmoPlugin

func get_name(): return "ECSG Object"

func is_ecsg_type(spatial, ecsg_type):
	return (
		spatial.has_method("is_ecsg")
		and spatial.is_ecsg()
		and spatial.has_method("get_ecsg_type")
		and spatial.get_ecsg_type() == ecsg_type
	)
