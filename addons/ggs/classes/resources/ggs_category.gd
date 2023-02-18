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
	settings[setting.key] = setting
	item_order.append(setting)


func remove_setting(setting: ggsSetting) -> void:
	settings.erase(setting.key)
	item_order.erase(setting)


func rename_setting(prev_name: String, setting: ggsSetting) -> void:
	settings.erase(prev_name)
	settings[setting.key] = setting
