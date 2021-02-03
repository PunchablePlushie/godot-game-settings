extends DropDownList


func _process(_delta: float) -> void:
	# Prevent the player from changing scale while fullscreen as it causes issues
	button.disabled = OS.window_fullscreen


func update_value(index: int) -> void:
	.update_value(index)
	SettingsManager.logic_window_scale(index)
