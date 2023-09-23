@tool
extends Resource
class_name ggsSetting

var current: Variant : set = set_current, get = get_current
var default: Variant : set = set_default
var name: String
var category: String
var value_type: Variant.Type
var value_hint: PropertyHint
var value_hint_string: String


func _get_property_list() -> Array:
	var usage: PropertyUsageFlags =  PROPERTY_USAGE_DEFAULT
	var enum_string_types: String = ggsUtils.get_enum_string("Variant.Type")
	var enum_string_property_hints: String = ggsUtils.get_enum_string("PropertyHint")

	var properties: Array
	properties.append_array([
		{"name": "Game Setting", "type": TYPE_NIL, "usage": PROPERTY_USAGE_CATEGORY},
		{"name": "current", "type": value_type, "usage": PROPERTY_USAGE_DEFAULT, "hint": value_hint, "hint_string": value_hint_string},
		{"name": "default", "type": value_type, "usage": PROPERTY_USAGE_DEFAULT, "hint": value_hint, "hint_string": value_hint_string},
		{"name": "Internal", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP},
		{"name": "name", "type": TYPE_STRING, "usage": usage},
		{"name": "category", "type": TYPE_STRING, "usage": usage},
		{"name": "value_type", "type": TYPE_INT, "usage": usage, "hint": PROPERTY_HINT_ENUM, "hint_string": enum_string_types},
		{"name": "value_hint", "type": TYPE_INT, "usage": usage, "hint": PROPERTY_HINT_ENUM, "hint_string": enum_string_property_hints},
		{"name": "value_hint_string", "type": TYPE_STRING, "usage": usage},
	])

	return properties


func set_current(value: Variant) -> void:
	current = value
	ggsSaveFile.new().set_key(category, name, value)


func update_category() -> void:
	category = _get_path_dict()["category"]
	ResourceSaver.save(self, resource_path)


func update_name() -> void:
	var path_dict: Dictionary = _get_path_dict()
	var group: String = ""
	
	if path_dict["group"].is_empty():
		name = path_dict["name"]
	else:
		name = "%s_%s"%[path_dict["group"], path_dict["name"]]
	
	var err = ResourceSaver.save(self, resource_path)
	prints(resource_path)


func _get_path_dict() -> Dictionary:
	var result: Dictionary = {
		"category": "",
		"group": "",
		"name": "",
	}
	
	var dir_settings: String = ggsUtils.get_plugin_data().dir_settings
	var base_path: String = resource_path.trim_prefix(dir_settings)
	var path_components: PackedStringArray = base_path.split("/", false)
	
	result["category"] = path_components[0]
	if path_components.size() == 3:
		result["group"] = path_components[1]
		result["name"] = path_components[2].get_basename()
	else:
		result["name"] = path_components[1].get_basename()
	
	
	return result


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


### Public Methods

func delete() -> void:
	set_script(load("res://addons/ggs/classes/resources/ggs_setting.gd"))
	resource_name = "[Deleted Setting]"


func save_plugin_data() -> void:
	if not Engine.is_editor_hint():
		return
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	if data != null:
		data.save()


func is_added() -> bool:
	return not category.is_empty()
