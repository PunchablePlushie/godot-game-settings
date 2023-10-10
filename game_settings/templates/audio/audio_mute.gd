@tool
extends ggsSetting

var audio_bus: String = "None"


func _init() -> void:
	value_type = TYPE_BOOL
	default = false


func apply(value: bool) -> void:
	if audio_bus == "None":
		printerr("GGS - Apply Setting (audio_mute.gd): No audio bus is selected.")
		return
	
	var bus_index: int = AudioServer.get_bus_index(audio_bus)
	AudioServer.set_bus_mute(bus_index, value)


### Bus Name

func _get_property_list() -> Array:
	var hint_string: String = ",".join(_get_audio_buses())
	return [{
		"name": "audio_bus",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": hint_string,
	}]


func _get_audio_buses() -> PackedStringArray:
	var buses: PackedStringArray = ["None"]
	for bus_index in range(AudioServer.bus_count):
		var bus: String = AudioServer.get_bus_name(bus_index)
		buses.append(bus)
	
	return buses

