@tool
extends ggsSetting

@export_category("Window Scale")
var current: int = 0: set = set_current
var default: int = 0
var scales: Array[int]: set = set_scales


func _init() -> void:
	name = "Window Scale"
	icon = preload("res://addons/ggs/assets/game_settings/display_scale.svg")
	desc = "Change window size by multiplying its width and height by a specific value."


func _get_property_list() -> Array:
	var hint_string: String = ",".join(_get_scales())
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
			"name": "scales",
			"type": TYPE_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "%s:"%[TYPE_INT],
		},
	]


func set_current(value: int) -> void:
	current = value
	GGS.setting_property_changed.emit(self, "current")


func set_scales(value: Array[int]) -> void:
	scales = value
	ggsUtils.get_editor_interface().call_deferred("inspect_object", self)


func apply(_value: int) -> void:
	pass


func _get_scales() -> PackedStringArray:
	var arr0: PackedStringArray
	for scale in scales:
		arr0.append(str(scale))
	
	var arr1: PackedStringArray
	for scale in arr0:
		arr1.append("x%s"%scale)
	
	return arr1
