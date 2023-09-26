@tool
extends Button
class_name ggsSettingItem

var path: String


func _ready() -> void:
	pressed.connect(_on_pressed)
	gui_input.connect(_on_gui_input)


func _on_pressed() -> void:
	if not FileAccess.file_exists(path):
		printerr("GGS - Inspect Setting: The setting resource (%s.tres) could not be found."%text)
		ggsUtils.get_editor_interface().inspect_object(null)
		return
	
	var setting_res: ggsSetting = load(path)
	ggsUtils.get_editor_interface().inspect_object(setting_res)


func _on_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_RIGHT
	):
		ggsUtils.get_editor_interface().select_file(path)
