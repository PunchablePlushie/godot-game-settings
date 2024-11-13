@tool
extends ggsSetting
class_name settingDisplayFullscreen
## Toggles window fullscreen mode.

## A setting that can handle window size. Used to set the game window to
## the correct size after its fullscreen state changes.
@export var size_setting: ggsSetting


func _init() -> void:
	value_type = TYPE_BOOL
	default = false
	section = "display"
	read_only_properties = ["value_type", "value_hint", "value_hint_string"]


func apply(value: bool) -> void:
	var window_mode: DisplayServer.WindowMode
	match value:
		true:
			window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		false:
			window_mode = DisplayServer.WINDOW_MODE_WINDOWED

	DisplayServer.window_set_mode(window_mode)

	if size_setting != null:
		var size_value: int = GGS.get_value(size_setting)
		size_setting.apply(size_value)

	GGS.setting_applied.emit(key, value)
