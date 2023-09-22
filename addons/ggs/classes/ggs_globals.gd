@tool
extends Node
signal category_selected(category: String)
signal active_category_updated()
signal setting_selected(setting: ggsSetting)

var active_category: String
var active_setting: ggsSetting

func update_save_file() -> void:
	var cur_category: String
	var cur_setting: String
	
	var dir_settings: String = ggsUtils.get_plugin_data().dir_settings
	var dir: DirAccess = DirAccess.open(dir_settings)
	var categories: PackedStringArray = dir.get_directories()
	for category in categories:
		cur_category = category
		
		dir.change_dir(dir_settings.path_join(category))
		var items: PackedStringArray = dir.get_directories()
		for item in items:
			if item.begins_with("-"):
				_update_save_file_recursive(dir, item, cur_category, cur_setting)
			else:
				cur_setting = item
				var res_path: String = "%s/%s/%s.tres"%[dir.get_current_dir(), item, item]
				var setting: ggsSetting = load(res_path)
				
				var save_file: ConfigFile = ggsSaveFile.new()
				save_file.set_key(cur_category, cur_setting, setting.current)
				save_file.save(save_file.path)


func _update_save_file_recursive(dir: DirAccess, group: String, cur_category: String, cur_setting: String) -> void:
	cur_setting += "%s_"%group.trim_prefix("-")
	
	dir.change_dir(dir.get_current_dir().path_join(group))
	var items: PackedStringArray = dir.get_directories()
	for item in items:
		if item.begins_with("-"):
			_update_save_file_recursive(dir, item, cur_category, cur_setting)
		else:
			cur_setting += item
			var res_path: String = "%s/%s/%s.tres"%[dir.get_current_dir(), item, item]
			var setting: ggsSetting = load(res_path)
			
			var save_file: ConfigFile = ggsSaveFile.new()
			save_file.set_key(cur_category, cur_setting, setting.current)
			save_file.save(save_file.path)


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

