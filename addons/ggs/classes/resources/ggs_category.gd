@tool
extends Resource
class_name ggsCategory

@export_category("Category")
@export_group("Internals")
@export var name: String: set = set_name
@export var settings: Dictionary #?1
@export var groups: Dictionary
@export var item_order: Array[ggsCatItem]


func set_name(value: String) -> void:
	name = value
	resource_name = value


### Settings

func add_setting(setting: ggsSetting) -> void:
	settings[setting.key] = setting
	
	if not setting.is_in_group():
		item_order.append(setting)


func remove_setting(setting: ggsSetting) -> void:
	settings.erase(setting.key)
	
	if not setting.is_in_group():
		item_order.erase(setting)


func rename_setting(prev_name: String, setting: ggsSetting) -> void:
	settings.erase(prev_name)
	settings[setting.key] = setting


#1: Prefix the key name with the setting group name. (e.g. Music_Volume, SFX_Volume, Move_Right_Keyboard, etc.)
