extends DropDownList

var window_base_size: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)


func update_value(index: int) -> void:
	.update_value(index)
	# Change window scale
	OS.window_size = window_base_size * (SettingsManager.get_setting(
			section_name, key_name) + 1)
	
	# Center window
	var display_center: Vector2 = OS.get_screen_size() / 2
	OS.window_position = display_center - (OS.window_size / 2)
