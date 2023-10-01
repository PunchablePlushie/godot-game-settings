@tool
extends Button

const URI: String = "https://forms.gle/c8XQzKHEqeMqxJ3Z9"


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	OS.shell_open(URI)
