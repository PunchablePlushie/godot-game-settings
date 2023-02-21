@tool
extends Resource
class_name ggsSetting

@export_category("Setting")
@export_group("Internal")
@export var name: String: set = set_name
@export var category: String
@export var icon: Texture2D
@export_multiline var desc: String


func _init() -> void:
	name = get_script().resource_path.get_file()
	icon = preload("res://addons/ggs/assets/game_settings/_default.svg")
	desc = "No description available."


func set_name(value: String) -> void:
	name = value
	resource_name = value
