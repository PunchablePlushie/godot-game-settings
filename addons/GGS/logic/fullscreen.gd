extends Node
# value: bool
#	Whether window is fullscreen or not
# window_script_path: String
#	Path to the logic script that's used for changing window size
# window_setting_index: int/String
#	The index of the window size setting in the settings list


func main(value: Dictionary) -> void:
	OS.window_fullscreen = value["value"]
	
	## Execute the window size logic again, in case the player changed the
	# window size while the window was at fullscreen.
	if value["value"] == false:
		var script_resource: Script = load(value["window_script_path"])
		var script_instance: Object = script_resource.new()
		var current = ggsManager.settings_data[str(value["window_setting_index"])]["current"]
		script_instance.main(current)
	
	OS.center_window()
