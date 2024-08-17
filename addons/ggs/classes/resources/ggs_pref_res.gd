@tool
extends Resource
class_name ggsPrefRes
## Plugin preferences resource.

## Various paths used throughout the plugin.
var paths: Dictionary = {
	"settings": "res://game_settings",
	"templates": "res://addons/ggs/templates",
	"components": "res://addons/ggs/components",
	"game_config": "user://settings.cfg",
}

## Visibility state of specific GGS editor elements.
var ui_vis: Dictionary = {
	"categories": {
		"add_field": true,
		"filter_field": true,
	},
	"groups": {
		"add_field": true,
		"filter_field": true,
	},
	"settings": {
		"add_bar": true,
		"filter_field": true,
	},
}