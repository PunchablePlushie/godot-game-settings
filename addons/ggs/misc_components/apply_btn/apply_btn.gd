extends Button

@export var group: String


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	get_tree().call_group(group, "apply_setting")
