@tool
extends ggsSetting

@export_category("Audio Mute")
@export var current: bool = false: set = set_current
@export var default: bool = false
var bus_name: String


func _init() -> void:
	name = "Audio Mute"
	icon = preload("res://addons/ggs/assets/game_settings/audio_mute.svg")
	desc = "Toggle mute state of a specific audio bus."


func _get_property_list() -> Array:
	var hint_string: String = ",".join(_get_audio_buses())
	return [{
		"name": "bus_name",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": hint_string,
	}]


func set_current(value: bool) -> void:
	current = value
	GGS.setting_property_changed.emit(self, "current")


func apply(_value: bool) -> void:
	pass


func _get_audio_buses() -> PackedStringArray:
	var buses: PackedStringArray
	for bus_index in range(AudioServer.bus_count):
		var bus_name: String = AudioServer.get_bus_name(bus_index)
		buses.append(bus_name)
	
	return buses
