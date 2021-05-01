tool
extends LineEdit

enum Type {Bool, Int, Float, Str, Arr, Dict}
var err_text: String
var saved: bool = false setget set_saved
onready var Root: HBoxContainer = get_node("../..")


func _ready() -> void:
	hint_tooltip = "Default Value"
	err_text = "GGS - %02d/Default_Value: Entered value cannot be converted to"%[Root.get_index()]


func _on_DefaultField_text_entered(new_text: String) -> void:
	var value = _to_suitable_type(new_text)
	ggsManager.settings_data[str(Root.get_index())]["default"] = value
	
	if value == null:
		ggsManager.settings_data[str(Root.get_index())]["default_raw"] = ""
		self.saved = false
	else:
		ggsManager.settings_data[str(Root.get_index())]["default_raw"] = new_text
		self.saved = true
		ggsManager.print_notif("%02d"%[Root.get_index()], "Default value saved (%s)"%[value])
		
		if Root.initialized == false:
			Root.AddScriptBtn.grab_focus()
	
	ggsManager.save_settings_data()


func _on_DefaultField_text_changed(new_text: String) -> void:
	self.saved = false


func set_saved(value: bool) -> void:
	saved = value
	if saved:
		modulate = ggsManager.COL_GOOD
	else:
		modulate = ggsManager.COL_ERR


func _to_suitable_type(input: String):
	var type: int = ggsManager.settings_data[str(Root.get_index())]["value_type"]
	var value: String = input.to_lower()
	var result
	
	match type:
		Type.Bool:
			result = Utils.str2bool(value)
			if result == null:
				printerr("%s boolean."%[err_text])
		Type.Int:
			result = Utils.str2int(value)
			if result == null:
				printerr("%s integer."%[err_text])
		Type.Float:
			result = Utils.str2float(value)
			if result == null:
				printerr("%s float."%[err_text])
		Type.Str:
			result = input
		Type.Arr:
			result = Utils.str2arr(value)
			if result == null:
				printerr("%s array."%[err_text])
		Type.Dict:
			result = Utils.str2dict(value)
			if result == null:
				printerr("%s dictionary."%[err_text])
	
	return result
