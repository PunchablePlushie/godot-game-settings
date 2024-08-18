@tool
extends ConfigFile
class_name ggsSaveFile

var path: String = GGS.Pref.data.paths["game_config"]


func _init() -> void:
	if not FileAccess.file_exists(path):
		save(path)
	
	self.load(path)


func set_key(section: String, key: String, value: Variant) -> void:
	set_value(section, key, value)
	save(path)
