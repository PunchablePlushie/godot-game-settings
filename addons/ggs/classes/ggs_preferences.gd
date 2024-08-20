@tool
extends Resource
class_name ggsPreferences
## GGS preferences resource.



## String used as a separator between subsection. When organizing settings
## inside the settings directory, any folder beyond the first counts as a
## subsection. View documentation for examples.
@export var subsect_seperator: String = "__": set = _set_subsect_separator

@export_group("Paths", "path_")
## Location of invdividual game setting. This should be where your
## [ggsSetting] resource instances are.
@export_dir var path_settings: String = "res://game_settings": set = _set_path_settings

## Location of setting templates. Setting templates can be used to
## create multiple instances of the same base setting.
@export_dir var path_templates: String = "res://addons/ggs/templates": set = _set_path_templates

## The file that will be used to save and load setting values during
## gameplay.[br]
## It will be saved in the user directory ([code]"user://"[/code]) and
## will be automatically created if it doesn't exist already.
@export var path_file: String = "user://settings.cfg"


func _set_subsect_separator(value: String) -> void:
	subsect_seperator = value
	GGS.Events.preferences_updated.emit("subsect_seperator", value)


func _set_path_settings(value: String) -> void:
	path_settings = value
	GGS.Events.preferences_updated.emit("path_settings", value)


func _set_path_templates(value: String) -> void:
	path_templates = value
	GGS.Events.preferences_updated.emit("path_templates", value)
