@tool
extends Resource
class_name ggsPluginData

const DIR_SETTINGS_DEFAULT: String = "res://game_settings/settings"
const DIR_TEMPLATES_DEFAULT: String = "res://game_settings/templates"
const DIR_COMPONENTS_DEFAULT: String = "res://game_settings/components"
const DIR_SAVE_FILE_DEFAULT: String = "user://settings.cfg"
const SPLIT_OFFSET_0_DEFAULT: int = -315
const SPLIT_OFFSET_1_DEFAULT: int = 615

@export_category("GGS Plugin Data")
@export var recent_settings: Array[String]
@export_group("Directories", "dir_")
@export_dir var dir_settings: String = DIR_SETTINGS_DEFAULT
@export_dir var dir_templates: String = DIR_TEMPLATES_DEFAULT
@export_dir var dir_components: String = DIR_COMPONENTS_DEFAULT
@export var dir_save_file: String = DIR_SAVE_FILE_DEFAULT
@export_group("Split Offset", "split_offset_")
@export var split_offset_0: int = SPLIT_OFFSET_0_DEFAULT
@export var split_offset_1: int = SPLIT_OFFSET_1_DEFAULT


func set_property(property: String, value: Variant) -> void:
	set(property, value)
	save()


func save() -> void:
	ResourceSaver.save(self)


func reset() -> void:
	recent_settings.clear()
	dir_settings = DIR_SETTINGS_DEFAULT
	dir_templates = DIR_TEMPLATES_DEFAULT
	dir_components = DIR_COMPONENTS_DEFAULT
	dir_save_file = DIR_SAVE_FILE_DEFAULT
	split_offset_0 = SPLIT_OFFSET_0_DEFAULT
	split_offset_1 = SPLIT_OFFSET_1_DEFAULT
	
	save()


### Recent Settings

func add_recent_setting(setting: String) -> void:
	if recent_settings.has(setting):
		_bring_to_front(setting)
	else:
		recent_settings.push_front(setting)
	
	_limit_size()
	save()


func _bring_to_front(element: String) -> void:
	recent_settings.erase(element)
	recent_settings.push_front(element)


func _limit_size() -> void:
	if recent_settings.size() > 10:
		recent_settings.pop_back()


func clear_recent_settings() -> void:
	recent_settings.clear()
	save()
