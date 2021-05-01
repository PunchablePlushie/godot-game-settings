tool
extends LineEdit

var saved: bool = false setget set_saved
onready var Root: HBoxContainer = get_node("..")


func _ready() -> void:
	hint_tooltip = "Setting Name"


func _on_NameField_text_entered(new_text: String) -> void:
	if Root.initialized == false:
		Root.DefaultType.grab_focus()
		
	ggsManager.settings_data[str(Root.get_index())]["name"] = new_text
	ggsManager.save_settings_data()
	
	ggsManager.print_notif("%02d"%[Root.get_index()], "Name saved ('%s')"%[new_text])
	self.saved = true


func _on_NameField_text_changed(new_text: String) -> void:
	self.saved = false


func set_saved(value: bool) -> void:
	saved = value
	if saved:
		modulate = ggsManager.COL_GOOD
	else:
		modulate = ggsManager.COL_ERR
