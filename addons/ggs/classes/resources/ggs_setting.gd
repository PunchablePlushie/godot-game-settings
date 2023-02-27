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


func update_save_file(value: Variant) -> void:
	ggsSaveFile.new().set_key(category, name, value)


func update_current() -> void:
	var save_file: ggsSaveFile = ggsSaveFile.new()
	var value: Variant
	if save_file.has_section_key(category, name):
		value = save_file.get_key(category, name)
	else:
		value = get("default")
		save_file.set_key(category, name, value)
	
	set("current", value)
