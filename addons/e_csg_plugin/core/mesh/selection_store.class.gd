class_name MeshCreator_Mesh_SelectionStore
extends Reference

var _store = Array()

func _init():
	_store = Array()
	
func get_store():
	return _store
	
func clear():
	_store.clear()
	
func are_selecteded(ids: PoolIntArray):
	for id in ids:
		if is_selected(id):
			return true
	return false	
	
func is_empty():
	return _store.empty()
	
func is_selected(id):
	return _store.has(id)
	
func add_many_to_selection(ids: PoolIntArray):
	for id in ids:
		add_to_selection(id)
		
func add_to_selection(id):
	remove_from_selection(id)
	_store.push_back(id)
	
func remove_from_selection(id):
	_store.erase(id)