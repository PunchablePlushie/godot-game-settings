extends DropDownList


func update_value(index: int) -> void:
	.update_value(index)
	GameSettings.logic_window_resolution(index)
