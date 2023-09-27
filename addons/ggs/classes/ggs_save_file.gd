@tool
extends ConfigFile
class_name ggsSaveFile

var path: String = ggsUtils.get_plugin_data().dir_save_file


func _init() -> void:
	if not FileAccess.file_exists(path):
		save(path)
	
	self.load(path)


func set_key(section: String, key: String, value: Variant) -> void:
	set_value(section, key, value)
	save(path)


func remake() -> void:
	clear()
	
	var all_settings: Array[ggsSetting] = GGS.get_all_settings()
	for setting in all_settings:
		set_value(setting.category, setting.name, setting.default)
	
	save(path)
	print("GGS - Remake Save File: Save file was remade successfully.")
