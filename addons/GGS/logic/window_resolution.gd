extends Node
# value: int
#	Index of one of the items in the 'resolution_list'.

# 'resolution_list' should be defined manually. Vector2(width, height).
var resolution_list: Array = [
	Vector2(640, 360),
	Vector2(1280, 720),
	Vector2(1920, 1080),
]


func main(value: Dictionary) -> void:
	OS.window_size = resolution_list[value["value"]]
	OS.center_window()
