@tool
extends Button

const URI: String = "https://github.com/PunchablePlushie/godot-game-settings/tree/3.1/addons/ggs/docs/home.md"


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	OS.shell_open(URI)
