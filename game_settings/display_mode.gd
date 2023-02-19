@tool
extends ggsSetting

enum DisplayMode {WINDOWED, BORDERLESS, FULLSCREEN}

@export_category("Display Mode")
@export var current: DisplayMode = DisplayMode.WINDOWED: set = set_current
@export var default: DisplayMode = DisplayMode.WINDOWED


func _init() -> void:
	name = "Display Mode"
	icon = preload("res://addons/ggs/assets/game_settings/display_mode.svg")
	desc = "Set window mode to Windowed, Borderless Fullscreen, or Fullscreen."


func set_current(value: DisplayMode) -> void:
	current = value
	GGS.setting_property_changed.emit(self, "current")


func apply(_value: DisplayMode) -> void:
	pass
