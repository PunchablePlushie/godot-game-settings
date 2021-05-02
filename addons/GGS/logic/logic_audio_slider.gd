extends Node


# Value is always an a array: [bus_name: String, volume: float]
func main(value: Array) -> void:
	var bus_index: int = AudioServer.get_bus_index(value[0])
	AudioServer.set_bus_volume_db(bus_index, linear2db(value[1]))
