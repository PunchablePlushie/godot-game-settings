extends HBoxContainer
## This version of the script doesn't support gamepad controls.
## If you want to support gamepad, detach this script and attach 
# "keybind_setting.gd" instead.
#!# Please note that gamepad support may be buggy and may not work as expected.

export(String) var setting_name: String
export(String) var section_name: String
export(String) var key_name: String
export(bool) var starts_with_focus: bool = false
export(String) var action_name: String

onready var label: Label = $Label
onready var keyboard_button: Button = $KeyboardBtn
onready var popup: PopupPanel = $PopupPanel


func _ready() -> void:
	if starts_with_focus:
		keyboard_button.grab_focus()
	
	set_process_input(false)
	label.text = setting_name
	
	# Keyboard
	keyboard_button.connect("pressed", self, "_on_KeyboardBtn_pressed")
	var scancode: int = SettingsManager.get_setting(section_name, key_name)
	var text: String = OS.get_scancode_string(scancode)
	keyboard_button.text = text


func _input(event: InputEvent) -> void:
	_change_keyboard_control(event)


func _on_KeyboardBtn_pressed() -> void:
	popup.popup_centered()
	set_process_input(true)
	SettingsManager.play_sfx(0)


func _change_keyboard_control(event: InputEvent) -> void:
	# Get the last keyboard key of the user
		if not event is InputEventKey:
			return
		var new_key: InputEventKey = event as InputEventKey
		
		# Replace the new key with the old key
		SettingsManager.logic_change_kb_control(action_name, new_key)
		
		# Update the config file
		SettingsManager.set_setting(section_name, key_name, new_key.scancode)
		
		# Update the text of setting button
		keyboard_button.text = OS.get_scancode_string(new_key.scancode)
		
		# Close the popup
		SettingsManager.play_sfx(0)
		popup.visible = false
		set_process_input(false)
		get_tree().set_input_as_handled()
