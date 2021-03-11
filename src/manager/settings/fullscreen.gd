extends BaseSetting


func set_value(value: bool) -> void:
	OS.window_fullscreen = value


func toggle() -> void:
	OS.window_fullscreen = !OS.window_fullscreen
