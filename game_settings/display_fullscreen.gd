@tool
extends ggsSetting

@export_category("Fullscreen Mode")
@export var current: bool = false: set = set_current
@export var default: bool = false


func _init() -> void:
	name = "Fullscreen Mode"
	icon = preload("res://addons/ggs/assets/game_settings/display_fullscreen.svg")
	desc = "Toggle Fullscreen mode."


func set_current(value: bool) -> void:
	current = value
	GGS.setting_property_changed.emit(self, "current")


func apply(_value: bool) -> void:
	pass
