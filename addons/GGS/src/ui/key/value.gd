tool
extends BaseInput

enum Type {_bool, _float, _String}
onready var Root: HBoxContainer = get_parent()


func convert_value(value: String) -> void:
	var key_name = Root.KeyNameField.text
	var result
	
	match Root.TypeSelectionBtn.selected:
		Type._String:
			result = value
		Type._bool:
			result = GGSUtils.str2bool(value)
		Type._float:
			result = GGSUtils.str2float(value)
	
	if result == null:
		self.saved = false
		ggsManager.print_err("%02d/ValueField(%d)"%[int(Root.index), Root.get_index()], "Entered value cannot be converted to the selected type.")
	else:
		self.saved = true
		ggsManager.settings_data[Root.index]["default"][key_name] = result
		ggsManager.settings_data[Root.index]["current"][key_name] = result
		ggsManager.save_settings_data()
		ggsManager.print_notif("%02d/Value"%[int(Root.index)], "'%s' was set to '%s'"%[Root.KeyNameField.text, result])


func _on_Value_text_entered(new_text: String) -> void:
	if editable:
		convert_value(new_text)


func _on_Value_text_changed(new_text: String) -> void:
	self.saved = false
