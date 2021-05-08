tool
extends Button

onready var Root: Control = get_node("../../../..")

func _ready() -> void:
	hint_tooltip = "Reload List"


func _on_Reload_pressed() -> void:
	ggsManager.print_notif("Reload", "Settings list reloaded.")
	Root.reload_settings()
