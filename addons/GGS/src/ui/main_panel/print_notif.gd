tool
extends CheckButton


func _ready() -> void:
	hint_tooltip = "If true, notifications will be printed to the 'Output'."
	pressed = ggsManager.ggs_data["show_prints"]


func _on_PrintNotif_toggled(button_pressed: bool) -> void:
	ggsManager.ggs_data["show_prints"] = button_pressed
	ggsManager.save_ggs_data()
