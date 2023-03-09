@tool
extends ggsSetting

var bus_name: String


func _init() -> void:
	name = "Audio Volume"
	icon = preload("res://addons/ggs/assets/game_settings/audio_volume.svg")
	desc = "Change volume of a specific audio bus."
	
	value_type = TYPE_FLOAT
	value_hint = PROPERTY_HINT_RANGE
	value_hint_string = "0,100"
	default = 80.0


func apply(_value: float) -> void:
	pass


### Bus Name

func _get_property_list() -> Array:
	var hint_string = ",".join(_get_audio_buses())
	
	var properties: Array
	properties.append({
		"name": "bus_name",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": hint_string,
	})
	
	return properties


func _get_audio_buses() -> PackedStringArray:
	var buses: PackedStringArray = []
	for bus_index in range(AudioServer.bus_count):
		var _bus_name_: String = AudioServer.get_bus_name(bus_index)
		buses.append(_bus_name_)
	
	return buses
