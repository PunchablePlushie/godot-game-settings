@tool
extends ggsSetting

@export var size_setting: ggsSetting


func _init() -> void:
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
	
	if size_setting != null:
		size_setting.apply(size_setting.current)
