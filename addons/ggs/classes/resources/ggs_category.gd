@tool
extends Resource
class_name ggsCategory

@export_category("Category")
@export var name: String: set = set_name
@export var groups: Array[ggsGroup]
@export var settings: Array[ggsSetting]


func set_name(value: String) -> void:
	name = value
	resource_name = value
