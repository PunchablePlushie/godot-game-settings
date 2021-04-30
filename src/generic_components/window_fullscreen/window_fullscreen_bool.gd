extends ggsBool


func update_value(button_state: bool) -> void:
	.update_value(button_state)
	GameSettings.Fullscreen.set_value(button_state)
