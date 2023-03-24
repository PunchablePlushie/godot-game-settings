extends Button

@export var settings: PackedScene


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	get_tree().change_scene_to_packed(settings)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_right", true):
		print("Action Triggered: move_right.")
	
	if Input.is_action_just_pressed("move_left", true):
		print("Action Triggered: move_left.")
	
	if Input.is_action_just_pressed("move_up", true):
		print("Action Triggered: move_up.")
	
	if Input.is_action_just_pressed("move_down", true):
		print("Action Triggered: move_down.")
