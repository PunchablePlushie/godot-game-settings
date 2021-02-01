class_name BoolSetting
extends BaseComponent

onready var label: Label = $Label
onready var button: CheckButton = $CheckButton

func _ready() -> void:
	button.pressed = SettingsManager.get_setting(section_name, key_name)
	label.text = setting_name


func update_value(button_state: bool) -> void:
	SettingsManager.set_setting(section_name, key_name, button_state)


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	update_value(button_pressed)
	SettingsManager.play_sfx(0)
