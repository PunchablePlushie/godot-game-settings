@tool
extends Node
signal category_selected(category: String)
signal active_category_updated()
signal setting_selected(setting: ggsSetting)

var active_category: String
var active_setting: ggsSetting

@onready var FSD: FileSystemDock = ggsUtils.get_file_system_dock()


func _on_FSD_files_moved(old: String, new: String) -> void:
	var dir_settings: String = ggsUtils.get_plugin_data().dir_settings
	if not new.begins_with(dir_settings):
		return
	
	var file: Resource = load(new) as ggsSetting
	if not file is ggsSetting:
		return
	
	prints(file.category, file.name)
	
	file.update_category()
	file.update_name()
	
	prints(file.category, file.name)


### Game Init

func _get_used_settings() -> Dictionary:
	var used_data: Dictionary
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	
	var categories: Dictionary = data.categories
	for category in categories.values():
		var used_keys: PackedStringArray
		for setting in category.settings.values():
			used_keys.append(setting.name)
		
		used_data[category.name] = used_keys
	
	return used_data


func _remove_unused_data(used_data: Dictionary) -> void:
	var save_file: ggsSaveFile = ggsSaveFile.new()
	var all_sections: PackedStringArray = save_file.get_sections()
	for section in all_sections:
		if not used_data.has(section):
			save_file.delete_section(section)
			continue
		
		var all_keys: PackedStringArray = save_file.get_section_keys(section)
		for key in all_keys:
			if not used_data[section].has(key):
				save_file.delete_key(section, key)


func _add_missing_data() -> void:
	var save_file: ggsSaveFile = ggsSaveFile.new()
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	for category in data.categories.values():
		for setting in category.settings.values():
			if save_file.has_section_key(setting.category, setting.name):
				continue
			
			save_file.set_key(setting.category, setting.name, setting.default)


func _apply_settings() -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	for category in data.categories.values():
		for setting in category.settings.values():
			var value: Variant = ggsSaveFile.new().get_key(setting.category, setting.name)
			setting.apply(value)


### Private

func _ready() -> void:
	
	FSD.files_moved.connect(_on_FSD_files_moved)
	category_selected.connect(_on_category_selected)
	setting_selected.connect(_on_setting_selected)
	return
	
	var used_data: Dictionary = _get_used_settings()
	_remove_unused_data(used_data)
	_add_missing_data()
	
	if not Engine.is_editor_hint():
		_apply_settings()


func _on_category_selected(category: String) -> void:
	active_category = category
	active_category_updated.emit()


func _on_setting_selected(setting: ggsSetting) -> void:
	active_setting = setting

