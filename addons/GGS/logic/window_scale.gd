extends Node

var min_window_scale: int = 1
var BASE_SIZE: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)


func main(value: int) -> void:
	OS.window_size = BASE_SIZE * (value + min_window_scale)
	OS.center_window()
