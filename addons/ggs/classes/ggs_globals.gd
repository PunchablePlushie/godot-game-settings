@tool
extends Node

### Signals

signal category_selected(category: ggsCategory)
signal setting_selected(setting: ggsSetting)


### Variables

var data: ggsPluginData = preload("../plugin_data.tres")
var active_category: ggsCategory
var active_setting: ggsSetting


### Game Init

func _get_used_settings() -> Dictionary:
	var used_data: Dictionary

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
		if used_data.has(section):
			var all_keys: PackedStringArray = save_file.get_section_keys(section)
			for key in all_keys:
				if used_data[section].has(key):
					continue

				save_file.delete_key(section, key)
		else:
			save_file.delete_section(section)


func _apply_settings() -> void:
	for category in GGS.data.categories.values():
		for setting in category.settings.values():
			var value: Variant = ggsSaveFile.new().get_key(setting.category, setting.name)
			setting.apply(value)


### Private

func _ready() -> void:
	category_selected.connect(_on_category_selected)
	setting_selected.connect(_on_setting_selected)
	
	var used_data: Dictionary = _get_used_settings()
	_remove_unused_data(used_data)
	
	if not Engine.is_editor_hint():
		_apply_settings()


func _on_category_selected(category: ggsCategory) -> void:
	active_category = category


func _on_setting_selected(setting: ggsSetting) -> void:
	active_setting = setting

