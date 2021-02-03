extends SliderSetting

export(String) var bus_name: String = "Master"


func _ready() -> void:
	# warning-ignore:narrowing_conversion
	slider.tick_count = (slider.max_value - slider.min_value) / slider.step + 1


func update_value(new_value: float) -> void:
	.update_value(new_value)
	SettingsManager.logic_audio_volume(bus_name, new_value)
