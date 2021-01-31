extends ArrowList

export(Dictionary) var resolutions: Dictionary = {
	"0": Vector2(640, 360),
	"1": Vector2(1280, 720),
	"2": Vector2(1980, 1080),
}


func update_value(new_value: int) -> void:
	.update_value(new_value)
	# Change resolution
	OS.window_size = resolutions[str(new_value)]
	
	# Center window
	var display_center: Vector2 = OS.get_screen_size() / 2
	OS.window_position = display_center - (OS.window_size / 2)
