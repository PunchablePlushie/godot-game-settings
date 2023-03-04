@tool
extends Button

@onready var PrefWindow: Window = %PrefWindow


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	PrefWindow.popup_centered(PrefWindow.min_size)
