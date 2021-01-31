extends ArrowList

export(String) var bus_name: String = "Master"
var scale_range: Vector2


func _ready() -> void:
	._ready()
	scale_range = Vector2(0, options_list.size() - 1)


func update_value(new_value: int) -> void:
	.update_value(new_value)
	# Remap the current value from scale_range to [0,1] range.
	var volume: float = range_lerp(new_value, 
			scale_range.x, scale_range.y,
			0, 1)
	# Change volume
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear2db(volume))
	print(AudioServer.get_bus_volume_db(bus_index))
