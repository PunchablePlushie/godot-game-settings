extends ArrowList

export(String) var bus_name: String = "Master"


func update_value(new_value: int) -> void:
	.update_value(new_value)
	var scale_range: Vector2 = Vector2(0, options_list.size() - 1)
	SettingsManager.logic_audio_volume_al(bus_name, new_value, scale_range)
