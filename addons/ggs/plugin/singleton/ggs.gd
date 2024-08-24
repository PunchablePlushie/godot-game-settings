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

## Name of the config file that will be used to save and load game settings.
@export var config_file: String = "settings.cfg"

## List of sections the config file will contain. Mainly used to provide
## suggestions when assigning the [param section] property of settings.
@export var sections: PackedStringArray

## List of all setting resources that will be used.
@export var settings: Array[ggsSetting]

var file_path: String
var file: ConfigFile = ConfigFile.new()


func _ready() -> void:
	_file_init()
	_file_clean_up()


func set_value(section: String, key: String, value: Variant) -> void:
	file.set_value(section, key, value)
	file.save(file_path)


func get_value(setting: ggsSetting) -> Variant:
	return file.get_value(setting.section, setting.key, setting.default)


func _file_init() -> void:
	file_path = BASE_PATH.path_join(config_file)
	if FileAccess.file_exists(file_path):
		file.load(file_path)
	
	file.save(file_path)


func _file_clean_up() -> void:
	var temp: Dictionary
	for section: String in file.get_sections():
		temp[section] = {}
		for key: String in file.get_section_keys(section):
			temp[section][key] = file.get_value(section, key)
	
	file.clear()
	
	for setting: ggsSetting in settings:
		if setting.key.is_empty():
			continue
		
		file.set_value(setting.section, setting.key, setting.default)
	
	for section: String in temp:
		if not file.has_section(section):
			continue
		
		for key: String in temp[section]:
			if not file.has_section_key(section, key):
				continue
			
			file.set_value(section, key, temp[section][key])
	
	file.save(file_path)
