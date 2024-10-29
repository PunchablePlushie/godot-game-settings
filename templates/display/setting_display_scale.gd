@tool
extends ggsSetting
class_name settingDisplayScale
## Sets the window scale. The window will be resized by multiplying its
## dimensions by a flat number.

## List of available scales.
@export var scales: Array[float]: set = _set_scales


func _init() -> void:
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	default = 0
	section = "display"
	read_only_properties = ["value_type", "value_hint", "value_hint_string"]


func _set_scales(value: Array[float]) -> void:
	scales = value

	if Engine.is_editor_hint():
		value_hint_string = ",".join(_get_scales_strings())
		notify_property_list_changed()


func apply(value: int) -> void:
	var scale: float = scales[value]
	var base_w: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var base_h: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	var size: Vector2 = Vector2(base_w, base_h) * scale
	size = ggsUtils.window_clamp_to_screen(size)

	DisplayServer.window_set_size(size)
	ggsUtils.window_center()
	GGS.setting_applied.emit(key, value)


func _get_scales_strings() -> PackedStringArray:
	var result: PackedStringArray = []
	for scale: float in scales:
		result.append("x%s"%[scale])

	return result
