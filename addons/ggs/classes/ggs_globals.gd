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

func _load_settings() -> Dictionary:
	var used_data: Dictionary
	
	var categories: Dictionary = ggsUtils.get_plugin_data().categories
	for category in categories.values():
		var used_keys: PackedStringArray
		print(category.name)
		for setting in category.settings.values():
			var section: String = setting.category
			var key: String = setting.name
			print(setting.name)
			used_keys.append(key)
			
			var save_file: ggsSaveFile = ggsSaveFile.new()
			if save_file.has_section_key(section, key):
				setting.current = save_file.get_key(section, key)
			else:
				setting.current = setting.default
				save_file.set_key(section, key, setting.default)
		
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
			setting.apply(setting.current)


### Private

func _ready() -> void:
	category_selected.connect(_on_category_selected)
	setting_selected.connect(_on_setting_selected)
	
	var used_data: Dictionary = _load_settings()
	_remove_unused_data(used_data)
	
	if not Engine.is_editor_hint():
		_apply_settings()


func _on_category_selected(category: ggsCategory) -> void:
	active_category = category


func _on_setting_selected(setting: ggsSetting) -> void:
	active_setting = setting

