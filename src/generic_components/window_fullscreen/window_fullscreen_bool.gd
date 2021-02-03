extends BoolSetting


func update_value(button_state: bool) -> void:
	.update_value(button_state)
	SettingsManager.logic_fullscreen(button_state)
