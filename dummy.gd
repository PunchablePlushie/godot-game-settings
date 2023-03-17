extends Control


func _process(_delta: float) -> void:
#	if Input.is_action_pressed("move_right"):
#		print("MOVING RIGHT")
#
#	if Input.is_action_pressed("move_left"):
#		print("MOVING LEFT")
#
	if Input.is_action_just_pressed("move_right", true):
		print("MOVED RIGHT")
	
	if Input.is_action_just_pressed("move_left", true):
		print("MOVED LEFT")
