@tool
extends ConfigFile
class_name ggsPluginPref
## Handles saving and loading plugin preferences data.

## Path for saving and loading the config file.
const FILE_PATH: String = "res://addons/ggs/plugin.pref"

## Default values of all preferences.
var DEFAULTS: Dictionary = {
	"dir_settings": "res://game_settings",
	"dir_templates": "res://game_settings/templates",
	"dir_components": "res://game_settings/components",
	"dir_game_config": "user://settings.cfg",
	"split_offset_0": -315,
	"split_offset_1": 615,
}

#const APPLY_ON_CHANGED_ALL_DEFAULT: bool = true
#const GRAB_FOCUS_ON_MOUSE_OVER_ALL: bool = true


func _init() -> void:
	var err: Error = self.load(FILE_PATH)
	if err:
		reset()


## Overrides the inherited [method ConfigFile.save].[br]
## In addition to the default saving behavior, it prints an error in case of failure.
func save(path: String) -> Error:
	var err: Error = super(path)
	if err:
		printerr("GGS: Save Editor Preferences - Could not save on disk (err: %s) (path: %s)"%[error_string(err), FILE_PATH])
	
	return err


## Checks if [param config_name] is a valid editor preference.[br]
## Only names that are part of [member DEFAULTS] are considered valid.
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
		self.save(FILE_PATH)
	
	return get_value("", config_name)


## Sets [param config_name] in the config file
## to [param value] and saves it.[br]
## Does nothing if [param config_name] is invalid.
func set_config(config_name: String, value: Variant) -> void:
	if not is_valid_config(config_name):
		printerr("GGS: Set Editor Preference - %s is not a valid key."%[config_name])
		return
	
	set_value("", config_name, value)
	self.save(FILE_PATH)


## Resets all keys to their default value. Also used to recreate the file
## if it doesn't exist.
func reset() -> void:
	for config in DEFAULTS:
		set_value("", config, DEFAULTS[config])
	
	self.save(FILE_PATH)


# Recent Settings #
func add_recent_setting(setting: String) -> void:
	pass


func _bring_to_front(element: String) -> void:
	pass


func _limit_size() -> void:
	pass


func clear_recent_settings() -> void:
	pass
