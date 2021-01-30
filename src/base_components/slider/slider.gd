extends Control

export(String) var setting_name: String
export(String) var section_name: String = ""
export(String) var key_name: String = ""

onready var label: Label = $HBoxContainer/Label
onready var slider: HSlider = $HBoxContainer/HSlider

func _ready() -> void:
	slider.value = SettingsManager.get_setting(section_name, key_name)
	label.text = setting_name


func _on_HSlider_value_changed(value: float) -> void:
	SettingsManager.set_setting(section_name, key_name, value)
