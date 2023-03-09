@tool
extends ggsSetting

@export_category("Window Size")
#var current: int = 0: set = set_current
#var default: int = 0
var sizes: Array[Vector2]: set = set_sizes


func _init() -> void:
	name = "Window Size"
	icon = preload("res://addons/ggs/assets/game_settings/display_size.svg")
	desc = "Change window size by setting its width and height to specific values."


func _get_property_list() -> Array:
	var hint_string: String = ",".join(_get_sizes())
	return [
		{
			"name": "current",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
		},
		{
			"name": "default",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
		},
		{
			"name": "sizes",
			"type": TYPE_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "%s:"%[TYPE_VECTOR2],
		},
	]


#func set_current(value: int) -> void:
#	current = value
#	update_save_file(value)


func set_sizes(value: Array[Vector2]) -> void:
	sizes = value
	ggsUtils.get_editor_interface().call_deferred("inspect_object", self)


func apply(_value: int) -> void:
	pass


func _get_sizes() -> PackedStringArray:
	var arr0: PackedStringArray
	for size in sizes:
		arr0.append(str(size))
	
	var arr1: PackedStringArray
	for size in arr0:
		var formatted_string: String = size.trim_prefix("(").trim_suffix(")").replace(",", " x")
		arr1.append(formatted_string)
	
	return arr1
