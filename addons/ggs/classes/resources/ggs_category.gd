@tool
extends Resource
class_name ggsCategory

var name: String: set = set_name
var settings: Dictionary
var item_order: Array[ggsSetting]


func _get_property_list() -> Array:
	var usage: PropertyUsageFlags = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
	
	var properties: Array
	properties.append_array([
		{"name": "Setting Category", "type": TYPE_NIL, "usage": PROPERTY_USAGE_CATEGORY},
		{"name": "Internal", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP},
		{"name": "name", "type": TYPE_STRING, "usage": usage},
		{"name": "settings", "type": TYPE_DICTIONARY, "usage": usage},
		{"name": "item_order", "type": TYPE_ARRAY, "usage": usage},
	])
	
	return properties


func set_name(value: String) -> void:
	name = value
	resource_name = value
	
	for setting in settings.values():
		setting.category = value


func _save_plugin() -> void:
	var plugin_data: ggsPluginData = ggsUtils.get_plugin_data()
	plugin_data.save()


### Settings

func add_setting(setting: ggsSetting) -> void:
	settings[setting.name] = setting
	item_order.append(setting)
	_save_plugin()


func remove_setting(setting: ggsSetting) -> void:
	settings.erase(setting.name)
	item_order.erase(setting)
	_save_plugin()


func rename_setting(prev_name: String, setting: ggsSetting) -> void:
	settings.erase(prev_name)
	settings[setting.name] = setting
	_save_plugin()


func get_setting_name_list() -> PackedStringArray:
	var name_list: PackedStringArray
	for setting in settings.values():
		name_list.append(setting.name)
	
	return name_list


func update_item_order(new_order: Array[ggsSetting]) -> void:
	item_order.clear()
	item_order = new_order
	_save_plugin()
