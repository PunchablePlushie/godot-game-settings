extends Node

var window_resolutions: Dictionary


func set_resolution(resolution_index: int) -> void:
	OS.window_size = window_resolutions[str(resolution_index)]
	OS.center_window()
