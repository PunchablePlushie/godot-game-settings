@tool
extends ggsSetting

var bus_name: String = "[NONE]": set = set_bus_name


func _init() -> void:
	name = "Audio Mute"
	icon = preload("res://addons/ggs/assets/game_settings/audio_mute.svg")
	desc = "Toggle mute state of a specific audio bus."
	
	value_type = TYPE_BOOL
	default = false


func apply(value: bool) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus_index, value)


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
