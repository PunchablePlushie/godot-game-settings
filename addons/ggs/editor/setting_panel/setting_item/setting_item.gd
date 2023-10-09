@tool
extends Button
class_name ggsSettingItem

var path: String
var btn_group: ButtonGroup


func _ready() -> void:
	toggled.connect(_on_toggled)
	gui_input.connect(_on_gui_input)
	
	button_group = btn_group


func _on_toggled(button_state: bool) -> void:
	if button_state == false:
		return
	
	if not FileAccess.file_exists(path):
		printerr("GGS - Inspect Setting: The setting resource (%s.tres) could not be found."%text)
		ggsUtils.get_editor_interface().inspect_object(null)
		return
	
	var setting_res: ggsSetting = load(path)
	
	if setting_res is ggsInputSetting:
		setting_res.update_current_as_event()
	
	GGS.active_setting = setting_res
	ggsUtils.get_editor_interface().inspect_object(setting_res)


func _on_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_RIGHT
	):
		ggsUtils.get_editor_interface().select_file(path)
