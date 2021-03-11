extends ArrowList


func update_value(new_value: int) -> void:
	.update_value(new_value)
	GameSettings.logic_window_resolution(new_value)
