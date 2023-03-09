@tool
extends ggsSetting


func _init() -> void:
	name = "Fullscreen Mode"
	icon = preload("res://addons/ggs/assets/game_settings/display_fullscreen.svg")
	desc = "Toggle Fullscreen mode."
	
	value_type = TYPE_BOOL
	default = false


func apply(value: bool) -> void:
	var window_mode: DisplayServer.WindowMode
	match value:
		true:
			window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		false:
			window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	
	DisplayServer.window_set_mode(window_mode)
