@tool
extends Resource
class_name ggsSetting

@export_category("Setting")
@export_group("Internal")
@export var name: String: set = set_name
@export var category: String
@export var icon: Texture2D = preload("res://addons/ggs/assets/preferences.svg")
@export_multiline var desc: String = "No description available."


func set_name(value: String) -> void:
	name = value
	resource_name = value
