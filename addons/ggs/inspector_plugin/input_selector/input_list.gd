@tool
extends Tree

var root: TreeItem


func load_list() -> void:
	clear()
	root = create_item()
	
	var input_map: Dictionary = _get_input_map()
	for action in input_map.keys():
		var action_item: TreeItem = _create_item(root, action)
		
		var index: int = 0
		for event in input_map[action]:
			_create_item(action_item, event.as_text(), {"event": event, "index": index})
			index += 1


func set_collapsed_all(collapsed: bool) -> void:
	var items: Array[TreeItem] = root.get_children()
	for item in items:
		item.set_collapsed_recursive(collapsed)


func _get_input_map() -> Dictionary:
	var input_map: Dictionary
	
	var project_file: ConfigFile = ConfigFile.new()
	project_file.load("res://project.godot")
	
	var actions: PackedStringArray = project_file.get_section_keys("input")
	for action in actions:
		var action_properties: Dictionary = project_file.get_value("input", action)
		var action_events: Array = action_properties["events"]
		
		input_map[action] = action_events
	
	return input_map


func _create_item(parent: TreeItem, text: String, meta: Dictionary = {}) -> TreeItem:
	var created_item: TreeItem = create_item(parent)
	created_item.set_text(0, text)
	
	if meta.is_empty():
		created_item.set_selectable(0, false)
	else:
		created_item.set_metadata(0, meta)
	
	return created_item
