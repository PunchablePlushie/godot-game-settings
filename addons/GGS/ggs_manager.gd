tool
extends Node

const SETTINGS_DATA_PATH: String = "res://addons/GGS/settings_data.json"
const GGS_DATA_PATH: String = "res://addons/GGS/ggs_data.json"

var settings_data: Dictionary = {}
var ggs_data: Dictionary = {
	"default_logic_path": "res://",
	"auto_select_new_nodes": true,
}


func _init() -> void:
	var file: File = File.new()
	if file.file_exists(SETTINGS_DATA_PATH):
		settings_data = _load_json(SETTINGS_DATA_PATH)
		
	if file.file_exists(GGS_DATA_PATH):
		ggs_data = _load_json(GGS_DATA_PATH)


func _ready() -> void:
	if Engine.editor_hint == false:
		_apply_settings()


func str2correct(value: String):
	var check: String = value.to_lower()
	
	# Convert to boolean if possible
	if check == "true":
		return true
	if check == "false":
		return false
	
	# Convert to float if possible
	if check.is_valid_float():
		return float(check)
	
	# Convert to integet if possible
	if check.is_valid_integer():
		return int(check)
	
	push_warning("GGS - str2correct: Redundant usage. No reason to convert string to string.")
	return value


func save_settings_data() -> void:
	_save_json(settings_data, SETTINGS_DATA_PATH)


func save_ggs_data() -> void:
	_save_json(ggs_data, GGS_DATA_PATH)


func _save_json(data: Dictionary, path: String) -> void:
	var data_stringified: String = JSON.print(data)
	var file: File = File.new()
	var err: int = file.open(path, File.WRITE)
	if err == OK:
		file.store_string(data_stringified)
		file.close()


func _load_json(path: String) -> Dictionary:
	var data: String = ""
	var file: File = File.new()
	var err: int = file.open(path, File.READ)
	if err == OK:
		data = file.get_as_text()
		file.close()
	var result: JSONParseResult = JSON.parse(data)
	
	return result.result


func _apply_settings() -> void:
	for item in settings_data:
		var setting: Dictionary = settings_data[item]
		if setting["logic"] != "":
			var script: Script = load(setting["logic"])
			var script_instance: Object = script.new()
			if setting["current"] == null:
				print(str2correct(setting["default"]))
				script_instance.main(str2correct(setting["default"]))
			else:
				script_instance.main(setting["current"])
