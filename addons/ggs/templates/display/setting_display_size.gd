@tool
extends ggsSetting
class_name settingDisplaySize
## Sets the window size. The window will be resized by setting its size
## to provided values.

## List of available sizes.
@export var sizes: Array[Vector2]: set = _set_sizes


func _init() -> void:
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	default = 0
	section = "display"
	read_only_properties = ["value_type", "value_hint", "value_hint_string"]


func _set_sizes(value: Array[Vector2]) -> void:
	sizes = value

	if Engine.is_editor_hint():
		value_hint_string = ",".join(_get_sizes_strings())
		notify_property_list_changed()


func apply(value: int) -> void:
	var size: Vector2 = sizes[value]
	size = ggsUtils.window_clamp_to_screen(size)

	DisplayServer.window_set_size(size)
	ggsUtils.window_center()
	GGS.setting_applied.emit(key, value)


func _get_sizes_strings() -> PackedStringArray:
	var result: PackedStringArray
	for size: Vector2 in sizes:
		var formatted_size: String = str(size).trim_prefix("(").trim_suffix(")").replace(",", " x")
		result.append(formatted_size)

	return result
