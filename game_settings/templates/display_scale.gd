@tool
extends ggsSetting

@export var scales: Array[float]: set = set_scales


func _init() -> void:
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = ",".join(_get_scales_strings())


func apply(value: int) -> void:
	var scale: float = scales[value]
	var base_w: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var base_h: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	var size: Vector2 = Vector2(base_w, base_h) * scale
	size = ggsUtils.window_clamp_to_screen(size)

	DisplayServer.window_set_size(size)
	ggsUtils.center_window()


### Scales

func set_scales(value: Array[float]) -> void:
	scales = value
	
	if Engine.is_editor_hint():
		value_hint_string = ",".join(_get_scales_strings())
		ggsUtils.get_editor_interface().call_deferred("inspect_object", self)


func _get_scales_strings() -> PackedStringArray:
	var scales_strings: PackedStringArray = []
	for scale in scales:
		scales_strings.append("x%s"%[str(scale)])
	
	return scales_strings
