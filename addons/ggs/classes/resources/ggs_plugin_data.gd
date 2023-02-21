@tool
extends Resource
class_name ggsPluginData

@export_category("GGS Data")
@export var categories: Dictionary
@export var category_order: Array[ggsCategory]
@export var recent_settings: Array[String]
@export var apply_on_change_default: bool = false

@export_group("Directories", "dir_")
@export_dir var dir_settings: String = "res://game_settings/settings"
@export_dir var dir_components: String = "res://game_settings/components"
@export_dir var dir_savefile: String = "user://settings.cfg"

@export_group("Split Offset", "split_offset_")
@export var split_offset_0: int = 0
@export var split_offset_1: int = 0


func set_data(data: String, value: Variant) -> void:
	set(data, value)
	_save_self()


func _save_self() -> void:
	ResourceSaver.save(self, resource_path)


### Categories

func add_category(category: ggsCategory) -> void:
	categories[category.name] = category
	category_order.append(category)
	_save_self()


func remove_category(category: ggsCategory) -> void:
	categories.erase(category.name)
	category_order.erase(category)
	_save_self()


func rename_category(prev_name: String, category: ggsCategory) -> void:
	categories.erase(prev_name)
	categories[category.name] = category
	_save_self()


func get_category_name_list() -> PackedStringArray:
	var name_list: PackedStringArray
	for category in categories.values():
		name_list.append(category.name)
	
	return name_list


func update_category_order(new_order: Array[ggsCategory]) -> void:
	category_order.clear()
	category_order = new_order
	_save_self()


### Recent Settings

func add_recent_setting(setting: ggsSetting) -> void:
	var script_name: String = setting.get_script().resource_path.get_file()
	
	if recent_settings.has(script_name):
		_bring_to_front(script_name)
	else:
		recent_settings.push_front(script_name)
	
	_limit_size()
	_save_self()


func _bring_to_front(element: String) -> void:
	recent_settings.erase(element)
	recent_settings.push_front(element)


func _limit_size() -> void:
	if recent_settings.size() > 10:
		recent_settings.pop_back()
