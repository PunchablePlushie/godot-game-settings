tool
extends CheckButton


func _ready() -> void:
	hint_tooltip = "If true, you will use cfg file save settings"
	pressed = ggsManager.ggs_data["use_cfg_save"]


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	ggsManager.ggs_data["use_cfg_save"] = button_pressed
	ggsManager.save_ggs_data()
