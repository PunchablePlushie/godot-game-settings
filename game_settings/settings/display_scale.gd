@tool
extends ggsSetting

@export var scales: Array[int]: set = set_scales


func _init() -> void:
	name = "Window Scale"
	icon = preload("res://addons/ggs/assets/game_settings/display_scale.svg")
	desc = "Change window size by multiplying its width and height by a specific value."
	
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = ",".join(_get_scales())


func apply(_value: int) -> void:
	pass


### Scales

func set_scales(value: Array[int]) -> void:
	scales = value
	value_hint_string = ",".join(_get_scales())
	ggsUtils.get_editor_interface().call_deferred("inspect_object", self)


func _get_scales() -> PackedStringArray:
	var arr0: PackedStringArray
	for scale in scales:
		arr0.append(str(scale))
	
	var arr1: PackedStringArray
	for scale in arr0:
		arr1.append("x%s"%scale)
	
	return arr1
