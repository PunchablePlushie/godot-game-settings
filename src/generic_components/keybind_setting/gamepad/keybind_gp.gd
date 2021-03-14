extends HBoxContainer

export(String) var action_name: String
export(String) var label_text: String
export(bool) var starts_with_focus: bool = false

onready var setting: Node = GameSettings.get_node("GpControls/%s"%action_name)
onready var label: Label = $Label
onready var button: Button = $Button
onready var popup: PopupPanel = $PopupPanel
onready var popup_label: Label = $PopupPanel/MarginContainer/Label


func _ready() -> void:
	if starts_with_focus:
		button.grab_focus()
	
	set_process_input(false)
	label.text = label_text
	
	button.connect("pressed", self, "_on_Button_pressed")
	var btn_index: int = GameSettings.get_setting(setting.section, setting.key)
	var button_string: String = Input.get_joy_button_string(btn_index)
	var text: String = _get_glyph_text(button_string)
	button.text = text
	
	## Experimental: Show the current button with a sprite instead of text.
	#button.text = ""
	#button.icon = _get_glyph_icon(button_string)


func _input(event: InputEvent) -> void:
	_change_controls(event)


func _on_Button_pressed() -> void:
	popup.popup_centered()
	set_process_input(true)


func _change_controls(event: InputEvent) -> void:
	# Get the last gamepad button of the user
	if not event is InputEventJoypadButton:
		return
	var new_btn: InputEventJoypadButton = event as InputEventJoypadButton
	
	# Check if key is already assigned
	var actions: Array = GameSettings.KbControls.actions
	for action in actions:
		if InputMap.event_is_action(new_btn, action):
			popup_label.text = "That button is already assigned..."
			return
		else:
			continue
	
	# Replace the new key with the old key
	GameSettings.GpControls.find_node(action_name).change(new_btn)
	
	# Update the config file
	GameSettings.set_setting(setting.section, setting.key, new_btn.button_index)
	
	# Update the text of setting button
	var button_string: String = Input.get_joy_button_string(new_btn.button_index)
	button.text = _get_glyph_text(button_string)
	
	## Experimental: Show the current button with a sprite instead of text.
	#button.text = ""
	#button.icon = _get_glyph_icon(button_string)
	
	# Close the popup
	popup.visible = false
	popup_label.text = "Press the new button..."
	get_tree().set_input_as_handled()
	set_process_input(false)


func _get_glyph_text(button_string: String) -> String:
	# Based on Xbox Controller
	var glyphs: Dictionary = {
		"Face Button Right": "B",
		"Face Button Top": "Y",
		"Face Button Left": "X",
		"Face Button Bottom": "A",
		"L": "L1",
		"L2": "L2",
		"L3": "L3",
		"R": "R1",
		"R2": "R2",
		"R3": "R3",
		"DPAD Up": "Up",
		"DPAD Left": "Left",
		"DPAD Down": "Down",
		"DPAD Right": "Right",
		"Select": "Select",
		"Start": "Start",
	}

	return glyphs[button_string]


func _get_glyph_icon(button_string: String) -> ImageTexture:
	var glyphs: Dictionary = {
		"Face Button Right": "", # Example: load("btn_right.png")
		"Face Button Top": "",
		"Face Button Left": "",
		"Face Button Bottom": "",
		"L": "",
		"L2": "",
		"L3": "",
		"R": "",
		"R2": "",
		"R3": "",
		"DPAD Up": "",
		"DPAD Left": "",
		"DPAD Down": "",
		"DPAD Right": "",
		"Select": "",
		"Start": "",
	}
	
	return glyphs[button_string]
