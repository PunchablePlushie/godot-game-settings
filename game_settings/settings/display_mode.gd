@tool
extends ggsSetting

enum DisplayMode {WINDOWED, BORDERLESS, FULLSCREEN}

@export_category("Display Mode")
@export var current: DisplayMode = DisplayMode.WINDOWED: set = set_current
@export var default: DisplayMode = DisplayMode.WINDOWED


func _init() -> void:
	super()
	
	name = "Display Mode"
	icon = preload("res://addons/ggs/assets/game_settings/display_mode.svg")
	desc = "Set window mode to Windowed, Borderless Fullscreen, or Fullscreen."


func set_current(value: DisplayMode) -> void:
	current = value
	update_save_file(value)


func apply(_value: DisplayMode) -> void:
	print(_value)
