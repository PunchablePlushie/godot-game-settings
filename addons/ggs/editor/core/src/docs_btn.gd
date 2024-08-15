@tool
extends Button

const URI: String = "https://github.com/PunchablePlushie/godot-game-settings/tree/main/docs/home.md"


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	OS.shell_open(URI)
