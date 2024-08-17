@tool
extends Resource
class_name ggsPrefRes
## Plugin preferences resource.

## Various paths used through the plugin.
@export var paths: Dictionary = {
	"settings": "res://game_settings",
	"templates": "res://addons/ggs/templates",
	"components": "res://addons/ggs/components",
	"game_config": "user://settings.cfg",
}

## Visibility state of specific UI elements.
var ui_vis: Dictionary = {
	"categories": {
		"add_field": true,
		"filter_field": true,
	},
}

## [code]split_offset[/code] of the [SplitContainers] in the GGS editor.
var split_offset: Array = [-315, 615]
