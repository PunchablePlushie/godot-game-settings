@tool
extends ggsSetting

@export var scales: Array[float]: set = set_scales


func _init() -> void:
	name = "Window Scale"
	icon = preload("res://addons/ggs/assets/game_settings/display_scale.svg")
	desc = "Change window size by multiplying its width and height by a specific value."
	
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = ",".join(_get_scales())


func apply(value: int) -> void:
	var scale: float = scales[value]
	var base_w: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var base_h: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	var size: Vector2 = Vector2(base_w * scale, base_h * scale)
	size = ggsUtils.window_clamp_to_screen(size)
	
	DisplayServer.window_set_size(size)
	ggsUtils.center_window()


### Scales

func set_scales(value: Array[float]) -> void:
	scales = value
	
	if not is_added():
		return
	
	save_plugin_data()
	
	if Engine.is_editor_hint():
		value_hint_string = ",".join(_get_scales())
		ggsUtils.get_editor_interface().call_deferred("inspect_object", self)


func _get_scales() -> PackedStringArray:
	var arr0: PackedStringArray = []
	for scale in scales:
		arr0.append(str(scale))
	
	var arr1: PackedStringArray = []
	for scale in arr0:
		arr1.append("x%s"%scale)
	
	return arr1
