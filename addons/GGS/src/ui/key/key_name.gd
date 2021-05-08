tool
extends BaseInput

var old_key: String
onready var Root: HBoxContainer = get_parent()


func _on_KeyName_text_changed(new_text: String) -> void:
	self.saved = false


func _on_KeyName_text_entered(new_text: String) -> void:
	var default: Dictionary = ggsManager.settings_data[Root.index]["default"]
	
	if default.has(old_key):
		default[new_text] = default[old_key]
		default.erase(old_key)
	else:
		default[new_text] = null
	ggsManager.settings_data[Root.index]["current"] = default
	ggsManager.save_settings_data()
	
	self.saved = true
	Root.ValueField.editable = true
	Root.TypeSelectionBtn.disabled = false
	Root.ValueField.grab_focus()
	old_key = new_text
