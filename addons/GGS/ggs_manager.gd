tool
extends Node

const SETTINGS_DATA_PATH: String = "res://addons/GGS/settings_data.json"
const GGS_DATA_PATH: String = "res://addons/GGS/ggs_data.json"

var settings_data: Dictionary = {}
var ggs_data: Dictionary = {
	"default_logic_path": "res://",
}


func _init() -> void:
	var file: File = File.new()
	if file.file_exists(SETTINGS_DATA_PATH):
		settings_data = load_json(SETTINGS_DATA_PATH)
	if file.file_exists(GGS_DATA_PATH):
		ggs_data = load_json(GGS_DATA_PATH)


func load_json(path: String) -> Dictionary:
	var data: String = ""
	var file: File = File.new()
	var err: int = file.open(path, File.READ)
	if err == OK:
		data = file.get_as_text()
		file.close()
	var result: JSONParseResult = JSON.parse(data)
	
	return result.result


func save_as_json(data: Dictionary, path: String) -> void:
	var data_stringified: String = JSON.print(data)
	var file: File = File.new()
	var err: int = file.open(path, File.WRITE)
	if err == OK:
		file.store_string(data_stringified)
		file.close()
