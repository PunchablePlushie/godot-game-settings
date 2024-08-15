@tool
extends Button

@onready var ggs_theme: Theme = preload("res://addons/ggs/editor/_theme/ggs_theme.tres")


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	ggs_theme.update()
