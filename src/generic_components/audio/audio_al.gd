extends ArrowList

export(String) var setting_name: String
export(String) var bus_name: String


func _ready() -> void:
	label.text = setting_name
	

func update_value(new_value: int) -> void:
	.update_value(new_value)
	GameSettings.AudioVolume.find_node(bus_name).set_volume(bus_name, new_value)
