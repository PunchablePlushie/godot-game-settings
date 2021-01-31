extends BoolSetting


func update_value(button_state: bool) -> void:
	.update_value(button_state)
	# Toggle fullscreen
	OS.window_fullscreen = button_state
