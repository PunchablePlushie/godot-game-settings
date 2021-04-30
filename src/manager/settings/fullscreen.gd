extends BaseSetting


func main(value) -> void:
	OS.window_fullscreen = value
#	WindowSize.choose_and_apply(GameSettings.get_setting(WindowSize.section, WindowSize.key))
