extends Control

export(String) var setting_name: String
export(String) var section_name: String = ""
export(String) var key_name: String = ""

onready var label: Label = $HBoxContainer/Label
onready var button: CheckButton = $HBoxContainer/CheckButton

func _ready() -> void:
	button.pressed = SettingsManager.get_setting(section_name, key_name)
	label.text = setting_name


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	SettingsManager.set_setting(section_name, key_name, button_pressed)
