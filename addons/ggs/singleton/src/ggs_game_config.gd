extends Node
## Handles everything related to game settings at runtime.


# Game Init
func get_all_settings() -> PackedStringArray:
	var all_settings: PackedStringArray
	
	var path: String = ggsPluginPref.new().get_config("dir_settings")
	var dir: DirAccess = DirAccess.open(path)
	var categories: PackedStringArray = dir.get_directories()
	for category in categories:
		if category.begins_with("_"):
			continue
		
		dir.change_dir(path.path_join(category))
		var settings: PackedStringArray = _get_settings_in_dir(dir)
		all_settings.append_array(settings)
		
		var groups: PackedStringArray = dir.get_directories()
		for group in groups:
			dir.change_dir(path.path_join(category).path_join(group))
			var subsettings: PackedStringArray = _get_settings_in_dir(dir)
			all_settings.append_array(subsettings)
	
	return all_settings


func _get_settings_in_dir(dir: DirAccess) -> PackedStringArray:
	var result: PackedStringArray
	
	var settings: PackedStringArray = dir.get_files()
	for setting in settings:
		if setting.ends_with(".gd"):
			continue
		
		result.append(dir.get_current_dir().path_join(setting))
	
	return result


func _apply_settings() -> void:
	var all_settings: PackedStringArray = get_all_settings()
	for setting_path in all_settings:
		var setting: ggsSetting = load(setting_path)
		var value: Variant = ggsSaveFile.new().get_value(setting.category, setting.name)
		setting.apply(value)
