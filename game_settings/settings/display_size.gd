@tool
extends ggsSetting

@export var sizes: Array[Vector2]: set = set_sizes


func _init() -> void:
	name = "Window Size"
	icon = preload("res://addons/ggs/assets/game_settings/display_size.svg")
	desc = "Change window size by setting its width and height to specific values."
	
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = ",".join(_get_sizes())


func apply(value: int) -> void:
	var size: Vector2 = sizes[value]
	size = ggsUtils.window_clamp_to_screen(size)
	
	DisplayServer.window_set_size(size)
	ggsUtils.center_window()


### Sizes

func set_sizes(value: Array[Vector2]) -> void:
	sizes = value
	
	if not is_added():
		return
	
	save_plugin_data()
	
	if Engine.is_editor_hint():
		value_hint_string = ",".join(_get_sizes())
		ggsUtils.get_editor_interface().call_deferred("inspect_object", self)
	


func _get_sizes() -> PackedStringArray:
	var arr0: PackedStringArray
	for size in sizes:
		arr0.append(str(size))
	
	var arr1: PackedStringArray
	for size in arr0:
		var formatted_string: String = size.trim_prefix("(").trim_suffix(")").replace(",", " x")
		arr1.append(formatted_string)
	
	return arr1
