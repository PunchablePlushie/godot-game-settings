tool
extends Node

const SETTINGS_DATA_PATH: String = "res://addons/GGS/settings_data.json"
const GGS_DATA_PATH: String = "res://addons/GGS/ggs_data.json"
const COL_ERR: Color = Color(1.0, 0.7, 0.7, 1.0)
const COL_GOOD: Color = Color(1.0, 1.0, 1.0, 1.0)

var settings_data: Dictionary = {}
var ggs_data: Dictionary = {
	"default_logic_path": "res://",
	"auto_select_new_nodes": true,
	"show_prints": false,
	"keybind_confirm_text": "Awaiting input...",
	"keybind_assigned_text": "Already assigned...",
	"gamepad_use_glyphs": true,
	"gamepad_glyphs_texture": "res://addons/GGS/assets/glyph/gamepad_glyphs.tres",
	"keyboard_use_glyphs": false,
	"keyboard_glyphs_texture": "",
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


func array_find_type(array: Array, type: String) -> Object:
	for item in array:
		var item_class: String = item.get_class()
		if item_class == type:
			return item
		else:
			continue
	return null


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
				script_instance.main(setting["default"])
			else:
				script_instance.main(setting["current"])
