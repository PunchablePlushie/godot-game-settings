@tool
extends ggsSetting

enum DisplayMode {WINDOWED, BORDERLESS, FULLSCREEN}

@export_category("Display Mode")
@export var default: DisplayMode = DisplayMode.WINDOWED
@export var current: DisplayMode = DisplayMode.WINDOWED


func _init() -> void:
	name = "Display Mode"
	icon = preload("res://addons/ggs/assets/game_settings/display_mode.svg")
	desc = "Set window mode to Windowed, Borderless Fullscreen, or Fullscreen."


func apply(_value: DisplayMode) -> void:
	pass
