extends Node

export(String) var file_path: String = "res://settings.cfg"
export(String, FILE, "*.cfg") var default_file: String


var _config: ConfigFile = ConfigFile.new()
var _sections: Array = []
var _keys: Dictionary = {}


func _ready() -> void:
	var error = _config.load(file_path)
	if error != OK:
		_config.load(default_file)


func get_setting(section: String, key: String):
	return _config.get_value(section, key, null)


func set_setting(section: String, key: String, value) -> void:
	_config.set_value(section, key, value)
	_config.save(file_path)
