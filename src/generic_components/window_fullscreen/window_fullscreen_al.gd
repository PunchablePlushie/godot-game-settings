extends ArrowList


func update_value(new_value: int) -> void:
	.update_value(new_value)
	GameSettings.Fullscreen.set_value(new_value)
