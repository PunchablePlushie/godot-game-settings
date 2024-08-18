@tool
extends Resource
class_name ggsPrefData
## Plugin preferences resource.

## Various paths used throughout the plugin.
@export var paths: Dictionary = {
	"settings": "res://game_settings",
	"templates": "res://addons/ggs/templates",
	"components": "res://addons/ggs/components",
	"game_config": "user://settings.cfg",
}
