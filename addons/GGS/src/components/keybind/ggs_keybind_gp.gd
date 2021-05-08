extends Button

export(int, 0, 99) var setting_index: int
var script_instance: Object

# Resources
onready var ConfirmPopup: PackedScene = preload("KeybindConfirm.tscn")


func _ready() -> void:
	# Load and set display value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var value: int
	value = current["value"]
	
	if icon != null:
		icon.current_frame = value
	else:
		text = _get_actual_string(Input.get_joy_button_string(value))
	
	# Load Script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("pressed", self, "_on_pressed")


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	var event: InputEventJoypadButton = InputEventJoypadButton.new()
	event.button_index = default["value"]
	_on_ConfirmPopup_confirmed(event)


func _on_pressed() -> void:
	var instance: PopupPanel = ConfirmPopup.instance()
	instance.type = 1
	instance.source = self
	add_child(instance)
	instance.popup_centered()
	instance.connect("confirmed", self, "_on_ConfirmPopup_confirmed", [], CONNECT_ONESHOT)
	release_focus()


func _on_ConfirmPopup_confirmed(event: InputEventJoypadButton) -> void:
	# Update save value
	var current: Dictionary = ggsManager.settings_data[str(setting_index)]["current"]
	current["value"] = event.button_index
	ggsManager.save_settings_data()
	
	# Update display value
	if icon != null:
		icon.current_frame = event.button_index
	else:
		text = _get_actual_string(Input.get_joy_button_string(event.button_index))
	
	# Execute the logic script
	script_instance.main(current)


func _get_actual_string(button_string: String) -> String:
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
