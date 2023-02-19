@tool
extends Resource
class_name ggsCategory

@export_category("Category")
@export_group("Internal")
@export var name: String: set = set_name
@export var settings: Dictionary
@export var item_order: Array[ggsSetting]


func set_name(value: String) -> void:
	name = value
	resource_name = value


### Settings

func add_setting(setting: ggsSetting) -> void:
	settings[setting.name] = setting
	item_order.append(setting)


func remove_setting(setting: ggsSetting) -> void:
	settings.erase(setting.name)
	item_order.erase(setting)


func rename_setting(prev_name: String, setting: ggsSetting) -> void:
	settings.erase(prev_name)
	settings[setting.name] = setting


func get_setting_name_list() -> PackedStringArray:
	var name_list: PackedStringArray
	for setting in settings.values():
		name_list.append(setting.name)
	
	return name_list


func update_item_order(new_order: Array[ggsSetting]) -> void:
	item_order.clear()
	item_order = new_order
