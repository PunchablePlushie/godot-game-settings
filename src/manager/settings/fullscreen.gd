extends BaseSetting

onready var WindowSize: Node = get_node("../WindowSize")


func set_value(value: bool) -> void:
	OS.window_fullscreen = value
	WindowSize.choose_and_apply(GameSettings.get_setting(WindowSize.section, WindowSize.key))
