class_name BoolSetting
extends BaseComponent

onready var button: CheckButton = $CheckButton


func _ready() -> void:
	if starts_with_focus:
		button.grab_focus()

	button.pressed = SettingsManager.get_setting(section_name, key_name)
	button.connect("toggled", self, "_on_CheckButton_toggled")
	update_value(button.pressed)


func update_value(button_state: bool) -> void:
	SettingsManager.set_setting(section_name, key_name, button_state)


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	update_value(button_pressed)
	SettingsManager.play_sfx(0)
