extends HBoxContainer

export(String) var action_name: String
export(String) var label_text: String
export(bool) var starts_with_focus: bool = false

onready var setting: Node = GameSettings.get_node("KbControls/%s"%action_name)
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
	var scancode: int = GameSettings.get_setting(setting.section, setting.key)
	var text: String = OS.get_scancode_string(scancode)
	button.text = text


func _input(event: InputEvent) -> void:
	_change_controls(event)


func _on_Button_pressed() -> void:
	popup.popup_centered()
	set_process_input(true)


func _change_controls(event: InputEvent) -> void:
	# Get the last keyboard key of the user
	if not event is InputEventKey:
		return
	var new_key: InputEventKey = event as InputEventKey
	
	# Check if key is already assigned
	var actions: Array = GameSettings.KbControls.actions
	for action in actions:
		if InputMap.event_is_action(new_key, action):
			popup_label.text = "That key is already assigned..."
			return
		else:
			continue
	
	# Replace the new key with the old key
	GameSettings.KbControls.find_node(action_name).change(new_key)
	
	# Update the config file
	GameSettings.set_setting(setting.section, setting.key, new_key.scancode)
	
	# Update the text of setting button
	button.text = OS.get_scancode_string(new_key.scancode)
	
	# Close the popup
	popup.visible = false
	popup_label.text = "Press the new key..."
	get_tree().set_input_as_handled()
	set_process_input(false)
