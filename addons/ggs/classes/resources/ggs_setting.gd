@tool
extends Resource
class_name ggsSetting

var current: Variant: set = set_current, get = get_current
var default: Variant
var value_type: Variant.Type
var value_hint: PropertyHint
var value_hint_string: String
var name: String: get = get_name
var category: String: get = get_category
var read_only_values: bool = false


func _get_property_list() -> Array:
	var read_only: PropertyUsageFlags =  PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
	var current_default_usage: PropertyUsageFlags = read_only if read_only_values else PROPERTY_USAGE_DEFAULT
	var enum_string_types: String = ggsUtils.get_enum_string("Variant.Type")
	var enum_string_property_hints: String = ggsUtils.get_enum_string("PropertyHint")
	
	var properties: Array
	properties.append_array([
		{"name": "Game Setting", "type": TYPE_NIL, "usage": PROPERTY_USAGE_CATEGORY},
		{"name": "current", "type": value_type, "usage": current_default_usage, "hint": value_hint, "hint_string": value_hint_string},
		{"name": "default", "type": value_type, "usage": current_default_usage, "hint": value_hint, "hint_string": value_hint_string},
		{"name": "Internal", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP},
		{"name": "name", "type": TYPE_STRING, "usage": read_only},
		{"name": "category", "type": TYPE_STRING, "usage": read_only},
		{"name": "value_type", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT, "hint": PROPERTY_HINT_ENUM, "hint_string": enum_string_types},
		{"name": "value_hint", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT, "hint": PROPERTY_HINT_ENUM, "hint_string": enum_string_property_hints},
		{"name": "value_hint_string", "type": TYPE_STRING, "usage": PROPERTY_USAGE_DEFAULT},
	])
	
	return properties


func _get(property: StringName) -> Variant:
	if property == "resource_name":
		resource_name = name
		return resource_name
	
	return null


func set_current(value: Variant) -> void:
	current = value
	
	if not category.is_empty() or not name.is_empty():
		ggsSaveFile.new().set_key(category, name, value)


func get_current() -> Variant:
	var save_file: ggsSaveFile = ggsSaveFile.new()
	if save_file.has_section_key(category, name):
		return save_file.get_value(category, name)
	else:
		return default


func get_name() -> String:
	var path_dict: Dictionary = _get_path_dict()
	var group: String = ""
	
	if path_dict["group"].is_empty():
		return path_dict["name"]
	else:
		return "%s_%s"%[path_dict["group"], path_dict["name"]]


func get_category() -> String:
	return _get_path_dict()["category"]


func _get_path_dict() -> Dictionary:
	var result: Dictionary = {
		"category": "",
		"group": "",
		"name": "",
	}
	
	if not ggsUtils.path_is_in_dir_settings(resource_path):
		return result
	
	var dir_settings: String = ggsUtils.get_plugin_data().dir_settings
	var base_path: String = resource_path.trim_prefix(dir_settings)
	var path_components: PackedStringArray = base_path.split("/", false)
	
	if path_components.size() < 2 or path_components.size() > 3:
		return result
	
	result["category"] = path_components[0]
	if path_components.size() == 3:
		result["group"] = path_components[1]
		result["name"] = path_components[2].get_basename()
	else:
		result["name"] = path_components[1].get_basename()
	
	return result
