extends ArrowList

export(Dictionary) var resolutions: Dictionary


func update_value(new_value: int) -> void:
	.update_value(new_value)
	# Change resolution
	OS.window_size = resolutions[str(new_value)]
	
	# Center window
	var display_center: Vector2 = OS.get_screen_size() / 2
	OS.window_position = display_center - (OS.window_size / 2)
