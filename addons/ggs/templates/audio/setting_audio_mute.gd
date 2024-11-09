@tool
extends ggsSetting
class_name settingAudioMute
## Toggles mute state of an audio bus.

## Target audio bus.
var audio_bus: String = "None"


func _init() -> void:
	value_type = TYPE_BOOL
	default = false
	section = "audio"
	read_only_properties = ["value_type", "value_hint", "value_hint_string"]


func _get_property_list() -> Array:
	var hint_string: String = ",".join(_get_audio_buses())
	return [
		{
			"name": "audio_bus",
			"type": TYPE_STRING,
			"usage": get_property_usage("audio_bus"),
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
		}
	]


func apply(value: bool) -> void:
	if audio_bus == "None":
		printerr("GGS - Apply Setting (audio_mute.gd): No audio bus is selected.")
		return

	var bus_idx: int = AudioServer.get_bus_index(audio_bus)
	AudioServer.set_bus_mute(bus_idx, value)
	GGS.setting_applied.emit(key, value)


func _get_audio_buses() -> PackedStringArray:
	var buses: PackedStringArray = ["None"]
	for bus_idx: int in range(AudioServer.bus_count):
		var bus: String = AudioServer.get_bus_name(bus_idx)
		buses.append(bus)

	return buses
