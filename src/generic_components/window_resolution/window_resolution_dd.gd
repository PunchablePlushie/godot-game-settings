extends DropDownList


func update_value(index: int) -> void:
	.update_value(index)
	SettingsManager.logic_window_resolution(index)
