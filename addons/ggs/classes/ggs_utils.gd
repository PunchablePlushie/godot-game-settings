@tool
extends RefCounted
class_name ggsUtils
## Utility functions used in Godot Game Settings plugin.


## Returns the editor's [code]EditorInterface[/code] instance.
static func get_editor_interface() -> EditorInterface:
	return EditorPlugin.new().get_editor_interface()


## Returns a unique string based on the provided [code]list[/code] (i.e. the returned value
## is a string unique in that list). If the [code]string[/code] already exists, it returns a
## the string with a numbered suffix (e.g. Node 1, Node 2, etc.).
static func get_unique_string(list: PackedStringArray, string: String) -> String:
	var cur_string: String = string
	var count: int = 2
	while list.has(cur_string):
		cur_string = "%s %d"%[string, count]
		count += 1
	
	return cur_string
