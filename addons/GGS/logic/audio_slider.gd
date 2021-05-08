extends Node
# value: float
#	A value between 0 and 1. The volume of the bus.
# bus_name: String
#	Name of the bus that'll be affected.


func main(value: Dictionary) -> void:
	var bus_index: int = AudioServer.get_bus_index(value["bus_name"])
	AudioServer.set_bus_volume_db(bus_index, linear2db(value["value"]))
