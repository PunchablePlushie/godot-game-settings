extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_right", true):
		print("Action Triggered: move_right.")
	
	if Input.is_action_just_pressed("move_left", true):
		print("Action Triggered: move_left.")
	
	if Input.is_action_just_pressed("move_up", true):
		print("Action Triggered: move_up.")
	
	if Input.is_action_just_pressed("move_down", true):
		print("Action Triggered: move_down.")
