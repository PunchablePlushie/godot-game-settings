@tool
extends ggsSetting

enum DisplayMode {WINDOWED, BORDERLESS, FULLSCREEN}

@export_category("Display Mode")
@export var current: DisplayMode = DisplayMode.WINDOWED
@export var default: DisplayMode = DisplayMode.WINDOWED


func _init() -> void:
	name = "Display Mode"
	icon = preload("res://addons/ggs/assets/game_settings/settings/display_mode.svg")
	desc = "Set window mode to Windowed, Borderless Fullscreen, or Fullscreen."


func apply(value: DisplayMode) -> void:
	pass
