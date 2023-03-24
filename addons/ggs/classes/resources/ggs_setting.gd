@tool
extends Resource
class_name ggsSetting

var current: Variant: set = set_current, get = get_current
var default: Variant: set = set_default
var name: String: set = set_name
var category: String
var icon: Texture2D
var desc: String
var value_type: Variant.Type
var value_hint: PropertyHint
var value_hint_string: String


func _init() -> void:
	name = get_script().resource_path.get_file()
	icon = preload("res://addons/ggs/assets/game_settings/_default.svg")
	desc = "No description available."


func _get_property_list() -> Array:
	var usage: PropertyUsageFlags =  PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
	var enum_string_types: String = ggsUtils.get_enum_string("Variant.Type")
	var enum_string_property_hints: String = ggsUtils.get_enum_string("PropertyHint")
	
	var properties: Array
	properties.append_array([
		{"name": "Setting (%s)"%name, "type": TYPE_NIL, "usage": PROPERTY_USAGE_CATEGORY},
		{"name": "current", "type": value_type, "usage": PROPERTY_USAGE_DEFAULT, "hint": value_hint, "hint_string": value_hint_string},
		{"name": "default", "type": value_type, "usage": PROPERTY_USAGE_DEFAULT, "hint": value_hint, "hint_string": value_hint_string},
		{"name": "Internal", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP},
		{"name": "name", "type": TYPE_STRING, "usage": usage},
		{"name": "category", "type": TYPE_STRING, "usage": usage},
		{"name": "icon", "type": TYPE_OBJECT, "usage": usage, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": "Texture2D"},
		{"name": "desc", "type": TYPE_STRING, "usage": usage, "hint": PROPERTY_HINT_MULTILINE_TEXT},
		{"name": "value_type", "type": TYPE_INT, "usage": usage, "hint": PROPERTY_HINT_ENUM, "hint_string": enum_string_types},
		{"name": "value_hint", "type": TYPE_INT, "usage": usage, "hint": PROPERTY_HINT_ENUM, "hint_string": enum_string_property_hints},
		{"name": "value_hint_string", "type": TYPE_STRING, "usage": usage},
	])
	
	return properties


func set_current(value: Variant) -> void:
	current = value
	
	if not is_added() or name == "[Deleted Setting]":
		return
	
	ggsSaveFile.new().set_key(category, name, value)


func get_current() -> Variant:
	var save_file: ggsSaveFile = ggsSaveFile.new()
	if save_file.has_section_key(category, name):
		return save_file.get_value(category, name)
	else:
		save_file.set_key(category, name, default)
		return default


func set_default(value: Variant) -> void:
	default = value
	
	if Engine.is_editor_hint():
		var plugin_data: ggsPluginData = ggsUtils.get_plugin_data()
		
		if plugin_data != null:
			plugin_data.save()


func set_name(value: String) -> void:
	name = value
	resource_name = value
	notify_property_list_changed()


### Public Methods

func delete() -> void:
	set_script(load("res://addons/ggs/classes/resources/ggs_setting.gd"))
	name = "[Deleted Setting]"


func save_plugin_data() -> void:
	if not Engine.is_editor_hint():
		return
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	if data != null:
		data.save()


func is_added() -> bool:
	return not category.is_empty()
