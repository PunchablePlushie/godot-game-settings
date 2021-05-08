tool
extends BaseInput

onready var Root: HBoxContainer = get_node("..")


func _ready() -> void:
	hint_tooltip = "Setting Name"


func _on_NameField_text_entered(new_text: String) -> void:
	ggsManager.settings_data[str(Root.get_index())]["name"] = new_text
	ggsManager.save_settings_data()
	
	ggsManager.print_notif("%02d"%[Root.get_index()], "Name saved ('%s')"%[new_text])
	self.saved = true


func _on_NameField_text_changed(new_text: String) -> void:
	self.saved = false
