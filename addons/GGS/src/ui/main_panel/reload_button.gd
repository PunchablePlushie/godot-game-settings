tool
extends Button
## I can't figure out how to make it work. Unused.

onready var Root: Control = get_node("../../../../..")

func _ready() -> void:
	hint_tooltip = "Reload List"


func _on_Reload_pressed() -> void:
	Root.reload_settings()
