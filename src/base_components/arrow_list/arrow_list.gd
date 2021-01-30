extends Control

export(String) var setting_name: String
export(String) var section_name: String = ""
export(String) var key_name: String = ""
export(Array, String) var options_list: Array

var _current_value: int

onready var setting_name_node: Label = $HBoxContainer/SettingName
onready var current_value_node: Label = $HBoxContainer/HBoxContainer/CurrentValue
onready var prev_btn: Button = $HBoxContainer/HBoxContainer/PrevBtn
onready var next_btn: Button = $HBoxContainer/HBoxContainer/NextBtn

func _ready() -> void:
	setting_name_node.text = setting_name
	_current_value = SettingsManager.get_setting(section_name, key_name)
	_update_option()


func _on_PrevBtn_pressed() -> void:
	_current_value = (_current_value - 1) % options_list.size()
	_update_option()


func _on_NextBtn_pressed() -> void:
	_current_value = (_current_value + 1) % options_list.size()
	_update_option()


func _update_option() -> void:
	current_value_node.text = options_list[_current_value]
	SettingsManager.set_setting(section_name, key_name, _current_value)
