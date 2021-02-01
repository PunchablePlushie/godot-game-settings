extends SliderSetting

export(String) var bus_name: String = "Master"
export(float, 1) var steps: float = 0.1


func _ready() -> void:
	# ._ready(): Note that the ready function gets called on the partent 
	# regardless. No need to call it twice.
	slider.step = steps
	if slider.ticks_on_borders:
		# warning-ignore:narrowing_conversion
		slider.tick_count = (slider.max_value - slider.min_value) / slider.step + 1


func update_value(new_value: float) -> void:
	.update_value(new_value)
	# Change volume of the bus
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear2db(new_value))
