@tool
extends Node
## The core GGS singleton. Handles everything that needs a persistent
## and global instance to function.

const BASE_PATH: String = "user://"

signal type_selector_requested
signal hint_selector_requested(type: Variant.Type)
signal input_selector_requested

signal type_selector_confirmed(type: Variant.Type)
signal hint_selector_confirmed(hint: PropertyHint)
signal input_selector_confirmed

## Name of the config _file that will be used to save and load game settings.
@export var config_file: String = "settings.cfg"

@export_dir var settings_dir: String = "res://game_settings"

var _file_path: String
var _file: ConfigFile = ConfigFile.new()
var _settings: Array[ggsSetting]

@onready var Popups: Node = $Popups
@onready var Audio: Node = $Audio


func _ready() -> void:
	_settings = _get_all_settings()
	_file_init()
	_file_clean_up()
	
	if not Engine.is_editor_hint():
		Popups.queue_free()
		_apply_all()


func _get_all_settings() -> Array[ggsSetting]:
	var result: Array[ggsSetting]
	var settings: PackedStringArray = _get_dir_settings(settings_dir)
	for setting: String in settings:
		var obj: Resource = load(setting)
		
		if obj is not ggsSetting:
			continue
		
		result.append(obj)
	
	return result


func _get_dir_settings(path: String) -> PackedStringArray:
	var result: PackedStringArray
	var dir_access: DirAccess = DirAccess.open(path)
	
	for file: String in dir_access.get_files():
		if file.get_extension() == "gd":
			continue
		
		var file_path: String = path.path_join(file)
		result.append(file_path)
	
	for dir: String in dir_access.get_directories():
		var dir_path: String = path.path_join(dir)
		var dir_settings: PackedStringArray = _get_dir_settings(dir_path)
		result.append_array(dir_settings)
	
	return result


func set_value(section: String, key: String, value: Variant) -> void:
	_file.set_value(section, key, value)
	_file.save(_file_path)


func get_value(setting: ggsSetting) -> Variant:
	return _file.get_value(setting.section, setting.key, setting.default)


func _file_init() -> void:
	_file_path = BASE_PATH.path_join(config_file)
	if FileAccess.file_exists(_file_path):
		_file.load(_file_path)
	
	_file.save(_file_path)


func _file_clean_up() -> void:
	var temp: Dictionary
	for section: String in _file.get_sections():
		temp[section] = {}
		for key: String in _file.get_section_keys(section):
			temp[section][key] = _file.get_value(section, key)
	
	_file.clear()
	
	for setting: ggsSetting in _settings:
		if setting.key.is_empty():
			continue
		
		_file.set_value(setting.section, setting.key, setting.default)
	
	for section: String in temp:
		if not _file.has_section(section):
			continue
		
		for key: String in temp[section]:
			if not _file.has_section_key(section, key):
				continue
			
			_file.set_value(section, key, temp[section][key])
	
	_file.save(_file_path)


func _apply_all() -> void:
	for setting: ggsSetting in _settings:
		var value: Variant = get_value(setting)
		setting.apply(value)
