tool
extends Node

const SETTINGS_DATA_PATH: String = "res://addons/GGS/settings_data.json"
const SETTINGS_SAVE_PATH: String = "user://settings_data.json"

const SETTINGS_DATA_CFG_PATH: String = "res://addons/GGS/settings_data.cfg"
const SETTINGS_SAVE_CFG_PATH: String = "user://settings_data.cfg"

const GGS_DATA_PATH: String = "res://addons/GGS/ggs_data.json"
const COL_ERR: Color = Color(1.0, 0.7, 0.7, 1.0)
const COL_GOOD: Color = Color(1.0, 1.0, 1.0, 1.0)
const COL_SELECTED: Color = Color("#fff6b6")

var script_clipboard: String = ""
var value_clipboard: Dictionary = {}
var settings_data: Dictionary = {}
var ggs_data: Dictionary = {
	"default_logic_path": "res://",
	"auto_select_new_nodes": true,
	"show_prints": true,
	"show_errors": true,
	"keybind_confirm_text": "Awaiting input...",
	"keybind_assigned_text": "Already assigned...",
	"use_cfg_save": false,
}


func _init() -> void:
	load_ggs_data()
	load_settings_data()


func _exit_tree() -> void:
	if not OS.is_debug_build():
		if ggs_data["use_cfg_save"] == true:
			GGSUtils.save_cfg(settings_data, SETTINGS_SAVE_CFG_PATH)
		else:
			GGSUtils.save_json(settings_data, SETTINGS_SAVE_PATH)


func _ready() -> void:
	if Engine.editor_hint == false:
		_apply_settings()


func save_settings_data() -> void:
	if ggs_data["use_cfg_save"] == true:
		GGSUtils.save_cfg(settings_data, SETTINGS_DATA_CFG_PATH)
	else:
		GGSUtils.save_json(settings_data, SETTINGS_DATA_PATH)


func save_ggs_data() -> void:
	GGSUtils.save_json(ggs_data, GGS_DATA_PATH)


func load_settings_data() -> void:
	var file: File = File.new()
	if OS.is_debug_build():
		if ggs_data["use_cfg_save"] == true:
			if file.file_exists(SETTINGS_DATA_CFG_PATH):
				settings_data = GGSUtils.load_cfg(SETTINGS_DATA_CFG_PATH)
			else:
				save_settings_data()
		else:
			if file.file_exists(SETTINGS_DATA_PATH):
				settings_data = GGSUtils.load_json(SETTINGS_DATA_PATH)
			else:
				save_settings_data()
	else:
		if ggs_data["use_cfg_save"] == true:
			if file.file_exists(SETTINGS_SAVE_CFG_PATH):
				settings_data = GGSUtils.load_cfg(SETTINGS_SAVE_CFG_PATH)
			elif file.file_exists(SETTINGS_DATA_CFG_PATH):
				settings_data = GGSUtils.load_cfg(SETTINGS_DATA_CFG_PATH)
			else:
				printerr("GGS - Load Data: Failed to load settings data.")
		else:
			if file.file_exists(SETTINGS_SAVE_PATH):
				settings_data = GGSUtils.load_json(SETTINGS_SAVE_PATH)
			elif file.file_exists(SETTINGS_DATA_PATH):
				settings_data = GGSUtils.load_json(SETTINGS_DATA_PATH)
			else:
				printerr("GGS - Load Data: Failed to load settings data.")


func load_ggs_data() -> void:
	var file: File = File.new()
	if file.file_exists(GGS_DATA_PATH):
		ggs_data = GGSUtils.load_json(GGS_DATA_PATH)
	else:
		save_ggs_data()


func print_notif(_for: String, message: String) -> void:
	if ggs_data["show_prints"] == true:
		print("GGS - %s: %s"%[_for, message])


func print_err(_for: String, message: String) -> void:
	if ggs_data["show_errors"] == true:
		printerr("GGS - %s: %s"%[_for, message])


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
