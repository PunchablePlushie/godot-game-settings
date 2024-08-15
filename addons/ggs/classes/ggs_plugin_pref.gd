@tool
extends ConfigFile
class_name ggsPluginPref
## Handles saving and loading plugin preferences data.

## Path for saving and loading the config file.
const FILE_PATH: String = "res://addon/ggs/plugin.pref"

## Default values of all preferences.
var DEFAULTS: Dictionary = {
	"dir_settings": "res://game_settings",
}

const APPLY_ON_CHANGED_ALL_DEFAULT: bool = true
const GRAB_FOCUS_ON_MOUSE_OVER_ALL: bool = true
const DIR_TEMPLATES_DEFAULT: String = "res://game_settings/templates"
const DIR_COMPONENTS_DEFAULT: String = "res://game_settings/components"
const DIR_SAVE_FILE_DEFAULT: String = "user://settings.cfg"
const SPLIT_OFFSET_0_DEFAULT: int = -315
const SPLIT_OFFSET_1_DEFAULT: int = 615


func _init() -> void:
	var err: Error = self.load(FILE_PATH)
	if err:
		reset()


## Checks if [param config_name] is a valid editor preference.
func is_valid_config(config_name: String) -> bool:
	return DEFAULTS.has(config_name)


## Gets the value of [param config_name] from the config file.
## The key is added with its default value if it doesn't exist.[br]
## Returns [code]null[/code] if [param config_name] is invalid.
func get_config(config_name: String) -> Variant:
	if not is_valid_config(config_name):
		printerr("GGS: Get Editor Preference - %s is not a valid key."%[config_name])
		return null
	
	if not has_section_key("", config_name):
		set_value("", config_name, DEFAULTS[config_name])
		save(FILE_PATH)
	
	return get_value("", config_name)


## Sets the value of [param config_name] in the config file
## to [param value] and saves it.[br]
## Does nothing if [param config_name] is invalid.
func set_config(config_name: String, value: Variant) -> void:
	if not is_valid_config(config_name):
		printerr("GGS: Set Editor Preference - %s is not a valid key."%[config_name])
		return
	
	set_value("", config_name, value)
	save(FILE_PATH)


## Resets all keys to their default value. Also used to recreate the file
## if it doesn't exist.
func reset() -> void:
	for config in DEFAULTS:
		set_value("", config, DEFAULTS[config])
	
	save(FILE_PATH)


# Recent Settings #
func add_recent_setting(setting: String) -> void:
	pass


func _bring_to_front(element: String) -> void:
	pass


func _limit_size() -> void:
	pass


func clear_recent_settings() -> void:
	pass
