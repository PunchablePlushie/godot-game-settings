@tool
extends ggsSetting

@export var sizes: Array[Vector2]: set = set_sizes


func _init() -> void:
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = ",".join(_get_sizes_strings())


func apply(value: int) -> void:
	var size: Vector2 = sizes[value]
	size = ggsUtils.window_clamp_to_screen(size)
	
	DisplayServer.window_set_size(size)
	ggsUtils.center_window()


### Sizes

func set_sizes(value: Array[Vector2]) -> void:
	sizes = value
	
	if Engine.is_editor_hint():
		value_hint_string = ",".join(_get_sizes_strings())
		ggsUtils.get_editor_interface().call_deferred("inspect_object", self)


func _get_sizes_strings() -> PackedStringArray:
	var sizes_strings: PackedStringArray
	for size in sizes:
		var formatted_size: String = str(size).trim_prefix("(").trim_suffix(")").replace(",", " x")
		sizes_strings.append(formatted_size)
	
	return sizes_strings
