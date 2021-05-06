extends Node

var res_list: Array


func main(value: int) -> void:
	OS.window_size = Vector2(res_list[value][0], res_list[value][1])
	OS.center_window()
