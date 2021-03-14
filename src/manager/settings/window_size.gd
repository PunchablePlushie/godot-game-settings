extends BaseSetting

enum Type {Scale, Resolution}

export(Type) var type: int = 0
export(int, 1, 10) var min_window_scale: int = 1
export(Dictionary) var window_resolutions: Dictionary

var BASE_SIZE: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)


func set_scale(scale: int) -> void:
	OS.window_size = BASE_SIZE * (scale + min_window_scale)
	_center_window()


func set_resolution(resolution_index: int) -> void:
	OS.window_size = window_resolutions[str(resolution_index)]
	_center_window()


func choose_and_apply(value) -> void:
	match type:
		Type.Scale:
			set_scale(value)
		Type.Resolution:
			set_resolution(value)


func _center_window() -> void:
	var display_center: Vector2 = OS.get_screen_size() / 2
	OS.window_position = display_center - (OS.window_size / 2)
