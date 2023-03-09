@tool
extends ggsSetting

enum DisplayMode {WINDOWED, BORDERLESS, FULLSCREEN}


func _init() -> void:
	name = "Display Mode"
	icon = preload("res://addons/ggs/assets/game_settings/display_mode.svg")
	desc = "Set window mode to Windowed, Borderless Fullscreen, or Fullscreen."
	
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = "Windowed,Borderless,Fullscreen"
	default = DisplayMode.WINDOWED


func apply(_value: DisplayMode) -> void:
	pass
