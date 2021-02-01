extends DropDownList

export(Dictionary) var resolutions: Dictionary


func update_value(index: int) -> void:
	.update_value(index)
	# Change resolution
	OS.window_size = resolutions[str(index)]
	
	# Center window
	var display_center: Vector2 = OS.get_screen_size() / 2
	OS.window_position = display_center - (OS.window_size / 2)
