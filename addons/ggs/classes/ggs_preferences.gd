@tool
extends Resource
class_name ggsPreferences
## GGS preferences resource.

## This is where your setting resources are.
@export_dir var settings: String = "res://game_settings"

## The file that will be used to save and load setting values during
## gameplay.[br]
## Recommended to be in the user directory ([code]"user://"[/code])
@export var file: String = "user://settings.cfg"
