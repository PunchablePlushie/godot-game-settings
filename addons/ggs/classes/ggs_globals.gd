@tool
extends Node
signal active_category_changed()
signal active_setting_changed()

var active_category: String: set = set_active_category
var active_setting: ggsSetting: set = set_active_setting


func _ready() -> void:
	update_save_file()
	
	if not Engine.is_editor_hint():
		_apply_settings()


func update_save_file() -> void:
	var start_time = Time.get_ticks_msec()
	var save_file: ggsSaveFile = ggsSaveFile.new()
	var fresh_save: ConfigFile = ConfigFile.new()
	
	var all_settings: Array[ggsSetting] = get_all_settings()
	for setting in all_settings:
		if save_file.has_section_key(setting.category, setting.name):
			var value: Variant = save_file.get_value(setting.category, setting.name)
			fresh_save.set_value(setting.category, setting.name, value)
		else:
			fresh_save.set_value(setting.category, setting.name, setting.default)
	
	fresh_save.save(ggsUtils.get_plugin_data().dir_save_file)
	var end_time = Time.get_ticks_msec()
	prints("Time:", end_time - start_time)


func set_active_category(value: String) -> void:
	active_category = value
	active_category_changed.emit()
	active_setting = null


func set_active_setting(value: ggsSetting) -> void:
	active_setting = value
	active_setting_changed.emit()


### Game Init

func get_all_settings() -> Array[ggsSetting]:
	var all_settings: Array[ggsSetting]
	
	var path: String = ggsUtils.get_plugin_data().dir_settings
	var dir: DirAccess = DirAccess.open(path)
	var categories: PackedStringArray = dir.get_directories()
	for category in categories:
		dir.change_dir(path.path_join(category))
		var settings: Array[ggsSetting] = _get_settings_in_dir(dir)
		all_settings.append_array(settings)
		
		var groups: PackedStringArray = dir.get_directories()
		for group in groups:
			dir.change_dir(path.path_join(category).path_join(group))
			var subsettings: Array[ggsSetting] = _get_settings_in_dir(dir)
			all_settings.append_array(subsettings)
	
	return all_settings


func _get_settings_in_dir(dir: DirAccess) -> Array[ggsSetting]:
	var result: Array[ggsSetting]
	
	var settings: PackedStringArray = dir.get_files()
	for setting in settings:
		if setting.ends_with(".gd"):
			continue
		
		var res: Resource = load(dir.get_current_dir().path_join(setting))
		if not res is ggsSetting:
			continue
		
		result.append(res as ggsSetting)
	
	return result


func _apply_settings() -> void:
	var all_settings: Array[ggsSetting] = get_all_settings()
	for setting in all_settings:
		setting.apply(setting.current)
