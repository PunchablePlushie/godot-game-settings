@tool
extends Node
signal active_category_changed()
signal setting_selected(setting: ggsSetting)

var active_category: String: set = set_active_category
var active_setting: ggsSetting


func set_active_category(value: String) -> void:
	active_category = value
	active_category_changed.emit()


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
	setting_selected.connect(_on_setting_selected)
	return
	
	var used_data: Dictionary = _get_used_settings()
	_remove_unused_data(used_data)
	_add_missing_data()
	
	if not Engine.is_editor_hint():
		_apply_settings()


func _on_setting_selected(setting: ggsSetting) -> void:
	active_setting = setting

