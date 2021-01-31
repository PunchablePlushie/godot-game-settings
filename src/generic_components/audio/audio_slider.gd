extends SliderSetting

export(String) var bus_name: String = "Master"


func update_value(new_value: float) -> void:
	.update_value(new_value)
	# Change volume of the bus
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear2db(new_value))
