@tool
extends RefCounted
class_name ggsUtils
## Utility functions used in Godot Game Settings plugin.


# Editor Components

## Returns the [code]EditorInterface[/code] instance.
static func get_editor_interface() -> EditorInterface:
	return EditorPlugin.new().get_editor_interface()


## Returns the Godot's default editor icon called [code]name[/code].
static func get_editor_icon(name: String) -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon(name, "EditorIcons")


# Misc
## Returns the text data of a specific setion-key pair from [i]plugin_text.cfg[/i].
static func get_plugin_text(section: String, key: String) -> String:
	var file: ConfigFile = ConfigFile.new()
	
	var error: int = file.load("res://addons/ggs/plugin_text.cfg")
	if error != OK:
		printerr("GGS - Plugin text data (plugin_text.cfg) could not be loaded. CODE: %d"%error)
		return ""
	
	if not file.has_section(section):
		printerr("GGS - Get Plugin Text Data - Could not find section '%s'"%section)
		return ""
	
	if not file.has_section_key(section, key):
		printerr("GGS - Get Plugin Text Data - Could not find key '%s'"%key)
		return ""
	
	return file.get_value(section, key)


## Returns a unique string based on the provided [code]list[/code] (i.e. the returned value
## is a string unique in that list). If the [code]string[/code] already exists, it returns a
## the string with a numbered suffix (e.g. Node 1, Node 2, etc.).
static func get_unique_string(list: PackedStringArray, string: String) -> String:
	var cur_string: String = string
	var count: int = 1
	while list.has(cur_string):
		cur_string = "%s %d"%[string, count]
		count += 1
	
	return cur_string
