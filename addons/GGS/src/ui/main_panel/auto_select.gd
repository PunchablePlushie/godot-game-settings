tool
extends CheckButton


func _ready() -> void:
	hint_tooltip = "If true, new nodes created through 'Add Node' menu will be selected automatically."
	pressed = ggsManager.ggs_data["auto_select_new_nodes"]


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	ggsManager.ggs_data["auto_select_new_nodes"] = button_pressed
	ggsManager.save_ggs_data()
