@tool
extends RefCounted
class_name ggsUtils


static func get_editor_interface() -> EditorInterface:
	return EditorScript.new().get_editor_interface()


static func get_unique_string(list: PackedStringArray, string: String) -> String:
	var cur_string: String = string
	var count: int = 2
	while list.has(cur_string):
		cur_string = "%s %d"%[string, count]
		count += 1
	
	return cur_string
