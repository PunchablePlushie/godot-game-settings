@tool
extends Resource
class_name ggsPreferences
## GGS preferences resource.

@export_group("Paths", "path_")
## Location of invdividual game setting. This should be where your
## [ggsSetting] resource instances are.
@export_dir var path_settings: String = "res://game_settings"

## Location of setting templates. Setting templates can be used to
## create multiple instances of the same base setting.
@export_dir var path_templates: String = "res://addons/ggs/templates"

## The file that will be used to save and load setting values during
## gameplay.[br]
## It will be saved in the user directory ([code]"user://"[/code]) and
## will be automatically created if it doesn't exist already.
@export var path_file: String = "user://settings.cfg"
