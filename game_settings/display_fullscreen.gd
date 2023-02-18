@tool
extends ggsSetting

@export_category("Fullscreen Mode")
@export var default: bool = false
@export var current: bool = false


func _init() -> void:
	name = "Fullscreen Mode"
	icon = preload("res://addons/ggs/assets/game_settings/display_fullscreen.svg")
	desc = "Toggle Fullscreen mode."


func apply(_value: bool) -> void:
	pass
