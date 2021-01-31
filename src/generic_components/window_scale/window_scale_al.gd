extends ArrowList

var window_base_size: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)


func update_value(new_value: int) -> void:
	.update_value(new_value)
	# Change window scale
	OS.window_size = window_base_size * (new_value + 1)
	
	# Center window
	var display_center: Vector2 = OS.get_screen_size() / 2
	OS.window_position = display_center - (OS.window_size / 2)
