extends Node

onready var p: Node = get_parent()


func set_volume(bus_name: String, value) -> void:
	match p.type:
		p.Type.Slide:
			_volume_use_slider(bus_name, value)
		p.Type.List:
			_volume_use_list(bus_name, value)


func _volume_use_slider(bus_name: String, volume: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear2db(volume))


func _volume_use_list(bus_name: String, new_value: int) -> void:
	var volume: float = range_lerp(new_value, 0, p.list_range, 0, 1)
	_volume_use_slider(bus_name, volume)
