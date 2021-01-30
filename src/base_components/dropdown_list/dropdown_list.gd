extends Control

export(String) var setting_name: String
export(String) var section_name: String = ""
export(String) var key_name: String = ""

onready var label: Label = $HBoxContainer/Label
onready var button: OptionButton = $HBoxContainer/OptionButton

func _ready() -> void:
	button.selected = SettingsManager.get_setting(section_name, key_name)
	label.text = setting_name


func _on_OptionButton_item_selected(index: int) -> void:
	SettingsManager.set_setting(section_name, key_name, index)
