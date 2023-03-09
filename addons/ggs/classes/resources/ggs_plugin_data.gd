@tool
extends Resource
class_name ggsPluginData

var categories: Dictionary
var category_order: Array[ggsCategory]
var recent_settings: Array[String]

var dir_settings: String = "res://game_settings/settings"
var dir_components: String = "res://game_settings/components"

var split_offset_0: int = -225
var split_offset_1: int = 440


func _get_property_list() -> Array:
	var usage: PropertyUsageFlags = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
	
	var properties: Array
	properties.append_array([
		{"name": "GGS Data", "type": TYPE_NIL, "usage": PROPERTY_USAGE_CATEGORY},
		{"name": "categories", "type": TYPE_DICTIONARY, "usage": usage},
		{"name": "category_order", "type": TYPE_ARRAY, "usage": usage},
		{"name": "recent_settings", "type": TYPE_ARRAY, "usage": usage},
		
		{"name": "Directories", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP},
		{"name": "dir_settings", "type": TYPE_STRING, "usage": usage},
		{"name": "dir_components", "type": TYPE_STRING, "usage": usage},
		
		{"name": "Split Offset", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP},
		{"name": "split_offset_0", "type": TYPE_INT, "usage": usage},
		{"name": "split_offset_1", "type": TYPE_INT, "usage": usage},
	])
	
	return properties


func set_data(data: String, value: Variant) -> void:
	set(data, value)
	save()


func save() -> void:
	ResourceSaver.save(self, resource_path)


func reset() -> void:
	categories.clear()
	category_order.clear()
	recent_settings.clear()
	dir_settings = "res://game_settings/settings"
	dir_components = "res://game_settings/components"
	split_offset_0 = -225
	split_offset_1 = 440
	save()


### Categories

func add_category(category: ggsCategory) -> void:
	categories[category.name] = category
	category_order.append(category)
	save()


func remove_category(category: ggsCategory) -> void:
	categories.erase(category.name)
	category_order.erase(category)
	save()


func rename_category(prev_name: String, category: ggsCategory) -> void:
	categories.erase(prev_name)
	categories[category.name] = category
	save()


func get_category_name_list() -> PackedStringArray:
	var name_list: PackedStringArray
	for category in categories.values():
		name_list.append(category.name)
	
	return name_list


func update_category_order(new_order: Array[ggsCategory]) -> void:
	category_order.clear()
	category_order = new_order
	save()


### Recent Settings

func add_recent_setting(setting: ggsSetting) -> void:
	var script_name: String = setting.get_script().resource_path.get_file()
	
	if recent_settings.has(script_name):
		_bring_to_front(script_name)
	else:
		recent_settings.push_front(script_name)
	
	_limit_size()
	save()


func _bring_to_front(element: String) -> void:
	recent_settings.erase(element)
	recent_settings.push_front(element)


func _limit_size() -> void:
	if recent_settings.size() > 10:
		recent_settings.pop_back()
