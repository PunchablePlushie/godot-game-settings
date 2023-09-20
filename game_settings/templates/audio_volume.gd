@tool
extends ggsSetting

var bus_name: String = "[NONE]": set = set_bus_name


func _init() -> void:
	name = "Audio Volume"
	icon = preload("res://addons/ggs/assets/game_settings/audio_volume.svg")
	desc = "Change volume of a specific audio bus."
	
	value_type = TYPE_FLOAT
	value_hint = PROPERTY_HINT_RANGE
	value_hint_string = "0,100"
	default = 80.0


func apply(value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = linear_to_db(value/100)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


### Bus Name

func set_bus_name(value: String) -> void:
	bus_name = value
	
	if is_added():
		save_plugin_data()


func _get_property_list() -> Array:
	if not is_added():
		return []
	
	var hint_string: String = ",".join(_get_audio_buses())
	return [{
		"name": "bus_name",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": hint_string,
	}]


func _get_audio_buses() -> PackedStringArray:
	var buses: PackedStringArray = ["[NONE]"]
	for bus_index in range(AudioServer.bus_count):
		var bus: String = AudioServer.get_bus_name(bus_index)
		buses.append(bus)
	
	return buses

