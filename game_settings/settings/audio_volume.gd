@tool
extends ggsSetting

@export_category("Audio Volume")
@export_range(0, 100) var current: float = 80: set = set_current
@export_range(0, 100) var default: float = 80
var bus_name: String


func _init() -> void:
	name = "Audio Volume"
	icon = preload("res://addons/ggs/assets/game_settings/audio_volume.svg")
	desc = "Change volume of a specific audio bus."


func _get_property_list() -> Array:
	var hint_string: String = ",".join(_get_audio_buses())
	return [{
		"name": "bus_name",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": hint_string,
	}]


func set_current(value: float) -> void:
	current = value
	update_save_file(value)


func apply(_value: float) -> void:
	pass


func _get_audio_buses() -> PackedStringArray:
	var buses: PackedStringArray
	for bus_index in range(AudioServer.bus_count):
		var bus_name: String = AudioServer.get_bus_name(bus_index)
		buses.append(bus_name)
	
	return buses
