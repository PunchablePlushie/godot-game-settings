extends ArrowList


func update_value(new_value: int) -> void:
	.update_value(new_value)
	SettingsManager.logic_fullscreen(new_value)
