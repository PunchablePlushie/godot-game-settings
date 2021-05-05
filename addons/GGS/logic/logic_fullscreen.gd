extends Node

var setting_index: int = 1
var script_res: Script = preload("logic_window_scale.gd")

func main(value: bool) -> void:
	OS.window_fullscreen = value
	
	## Execute the window size logic again, in case the player changed the
	# window size while the window was at fullscreen.
	if value == false:
		var script_instance: Object = script_res.new()
		var current = ggsManager.settings_data[str(setting_index)]["current"]
		script_instance.main(current)
	
	OS.center_window()
