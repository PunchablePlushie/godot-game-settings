extends ArrowList


func update_value(new_value: int) -> void:
	.update_value(new_value)
	# Toggle fullscreen
	OS.window_fullscreen = bool(new_value)
