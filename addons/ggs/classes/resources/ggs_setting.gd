@tool
@icon("res://addons/ggs/assets/classes/setting.svg")
extends ggsCatItem
class_name ggsSetting

@export_category("Setting")
@export var name: String: set = set_name
@export_group("Setting Internals")
@export var key: String: set = set_key
@export var group: String


func set_name(value: String) -> void:
	name = value
	key = name


func set_key(value: String) -> void:
	if is_in_group():
		key = "%s_%s"%[group, value]
	else:
		key = value


### Public

func is_in_group() -> bool:
	return not group.is_empty()
