tool
extends CheckButton


func _ready() -> void:
	hint_tooltip = "If true, errors will be printed to the 'Output'."
	pressed = ggsManager.ggs_data["show_errors"]


func _on_PrintErr_toggled(button_pressed: bool) -> void:
	ggsManager.ggs_data["show_errors"] = button_pressed
	ggsManager.save_ggs_data()
