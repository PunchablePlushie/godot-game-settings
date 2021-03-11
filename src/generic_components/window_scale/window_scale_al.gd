extends ArrowList


func _process(_delta: float) -> void:
	# Prevent the player from changing scale while fullscreen as it causes issues
	prev_btn.disabled = OS.window_fullscreen
	next_btn.disabled = OS.window_fullscreen


func update_value(new_value: int) -> void:
	.update_value(new_value)
	GameSettings.WindowSize.set_scale(new_value)
