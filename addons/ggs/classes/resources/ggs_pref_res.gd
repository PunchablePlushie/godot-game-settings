@tool
extends Resource
class_name ggsPrefRes
## Plugin preferences resource.

## Various paths used throughout the plugin.
@export var paths: Dictionary = {
	"settings": "res://game_settings",
	"templates": "res://addons/ggs/templates",
	"components": "res://addons/ggs/components",
	"game_config": "user://settings.cfg",
}

## Visibility state of specific GGS editor elements.
@export var ui_vis: Dictionary = {
	"categories": {
		"new_field": true,
		"filter_field": true,
	},
	"groups": {
		"new_field": true,
		"filter_field": true,
	},
	"settings": {
		"add_bar": true,
		"filter_field": true,
	},
}
