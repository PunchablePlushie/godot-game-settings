@tool
extends ConfigFile
class_name ggsSaveFile

var path: String = "user://settings.cfg"


func _init() -> void:
	if not FileAccess.file_exists(path):
		save(path)
	
	self.load(path)


func set_key(section: String, key: String, value: Variant) -> void:
	set_value(section, key, value)
	save(path)


func get_key(section: String, key: String) -> Variant:
	return get_value(section, key)


func delete_key(section: String, key: String) -> void:
	erase_section_key(section, key)
	save(path)


func delete_section(section: String) -> void:
	erase_section(section)
	save(path)


func rename_section(prev_name: String, new_name: String) -> void:
	var section_data: Dictionary = _get_section_data(prev_name)
	erase_section(prev_name)
	
	for key in section_data:
		set_value(new_name, key, section_data[key])
	
	save(path)


func rename_key(section: String, prev_name: String, new_name: String) -> void:
	var key_value: Variant = get_value(section, prev_name)
	erase_section_key(section, prev_name)
	set_value(section, new_name, key_value)
	save(path)


func reset() -> void:
	for category in GGS.data.categories.values():
		for setting in category.settings.values():
			set_key(setting.category, setting.name, setting.default)
	
	save(path)
	print("GGS - Reset Save File: Save file values were reset successfully.")


func _get_section_data(section: String) -> Dictionary:
	var section_data: Dictionary
	for key in get_section_keys(section):
		section_data[key] = get_value(section, key)
	
	return section_data
