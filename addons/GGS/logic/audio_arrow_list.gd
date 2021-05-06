extends Node

# Value is always an a array: [bus_name: String, volume: float, list_length: int]
func main(value: Array) -> void:
	var volume: float = range_lerp(value[1], 0, value[2], 0, 1)
	var bus_index: int = AudioServer.get_bus_index(value[0])
	AudioServer.set_bus_volume_db(bus_index, linear2db(value[1]))
