extends HBoxContainer
### Gamepad settings might not work as expected as I didn't have a gamepad
### to test it. Please report any issues you've found on github.
### Simply set "support gamepad" to false to disable... well... gamepad support.

enum InputTypes {
	KEYBOARD,
	GAMEPAD,
}

export(String) var setting_name: String
export(String) var section_name: String
export(String) var kb_key_name: String
export(String) var gp_key_name: String
export(String) var action_name: String
export(bool) var support_gamepad: bool = false

var _current_type = -1

onready var label: Label = $Label
onready var keyboard_button: Button = $KeyboardBtn
onready var gamepad_button: Button = $GamepadBtn
onready var popup: PopupPanel = $PopupPanel


func _ready() -> void:
	set_process_input(false)
	label.text = setting_name
	
	# Keyboard
	keyboard_button.connect("pressed", self, "_on_KeyboardBtn_pressed")
	var scancode: int = SettingsManager.get_setting(section_name, kb_key_name)
	var text: String = OS.get_scancode_string(scancode)
	keyboard_button.text = text
	
	# Gamepad
	if support_gamepad == false:
		gamepad_button.visible = false
		return
	
	gamepad_button.connect("pressed", self, "_on_GamepadBtn_pressed")
	scancode = SettingsManager.get_setting(section_name, gp_key_name)
	text = Input.get_joy_button_string(scancode)
	gamepad_button.text = text


func _input(event: InputEvent) -> void:
	match _current_type:
		InputTypes.KEYBOARD:
			_change_keyboard_control(event)
		InputTypes.GAMEPAD:
			_change_gamepad_control(event)


func _on_KeyboardBtn_pressed() -> void:
	_current_type = InputTypes.KEYBOARD
	popup.popup_centered()
	set_process_input(true)


func _on_GamepadBtn_pressed() -> void:
	_current_type = InputTypes.GAMEPAD
	popup.popup_centered()
	set_process_input(true)


func _change_keyboard_control(event: InputEvent) -> void:
	# Get the last keyboard key of the user
		if not event is InputEventKey:
			return
		var new_key: InputEventKey = event as InputEventKey
		
		# Replace the new key with the old key
		var action_list: Array = InputMap.get_action_list(action_name)
		InputMap.action_erase_event(action_name, action_list[0])
		InputMap.action_add_event(action_name, new_key)
		
		# Update the config file
		SettingsManager.set_setting(section_name, kb_key_name, new_key.scancode)
		
		# Update the text of setting button
		keyboard_button.text = OS.get_scancode_string(new_key.scancode)
		
		# Close the popup
		popup.visible = false
		_current_type = -1


func _change_gamepad_control(event: InputEvent) -> void:
	# Get the last gamepad button of the user
		if not event is InputEventJoypadButton:
			return
		var new_btn: InputEventJoypadButton = event as InputEventJoypadButton
		
		# Replace the new button with the old button
		var action_list: Array = InputMap.get_action_list(action_name)
		InputMap.action_erase_event(action_name, action_list[1])
		InputMap.action_add_event(action_name, new_btn)
		
		# Update the config file
		SettingsManager.set_setting(section_name, gp_key_name, new_btn.button_index)
		
		# Update the text of setting button
		gamepad_button.text = Input.get_joy_button_string(new_btn.button_index)
		
		# Close the popup
		popup.visible = false
		_current_type = -1
