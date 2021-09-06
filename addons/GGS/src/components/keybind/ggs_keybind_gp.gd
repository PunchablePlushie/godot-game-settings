extends Button

export(int, 0, 99) var setting_index: int
var script_instance: Object

# Resources
onready var ConfirmPopup: PackedScene = preload("KeybindConfirm.tscn")


func _ready() -> void:
	# Load and set display value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var value: int = current["value"]
	
	if current.has("axis"):
		use_axis_icon(value, current["axis"])
	else:
		use_button_icon(value)
	
	# Load Script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("pressed", self, "_on_pressed")
	connect("mouse_entered", self, "_on_mouse_entered")


func use_button_icon(value: int) -> void:
	if icon != null:
		set_icon(value)
	else:
		text = _get_actual_string(Input.get_joy_button_string(value))


func use_axis_icon(value: int, axis: int) -> void:
	if icon != null:
		match axis:
			JOY_AXIS_0:
				if value < 0:
					set_icon(23)
				else:
					set_icon(24)
			JOY_AXIS_1:
				if value < 0:
					set_icon(25)
				else:
					set_icon(26)
			JOY_AXIS_2:
				if value < 0:
					set_icon(27)
				else:
					set_icon(28)
			JOY_AXIS_3:
				if value < 0:
					set_icon(29)
				else:
					set_icon(30)
	else:
		var axis_name: String = Input.get_joy_axis_string(axis)
		var axis_dir: String = _get_axis_dir_string(axis, value)
		text = "%s %s"%[axis_name, axis_dir]


func set_icon(value : int) -> void:
	if value >= 0 and value < icon.frames:
		icon.current_frame = value
	else:
		# Code for key not handled. Set current frame to empty
		icon.current_frame = 31


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	var event: InputEvent
	
	if default.has("axis"):
		event = InputEventJoypadMotion.new() as InputEventJoypadMotion
		event.axis = default["axis"]
		event.value = default["value"]
	else:
		event = InputEventJoypadButton.new() as InputEventJoypadButton
		event.button_index = default["value"]
	
	_on_ConfirmPopup_confirmed(event)


# Handle mouse focus
func _on_mouse_entered() -> void:
	grab_focus()


func _on_pressed() -> void:
	var instance: PopupPanel = ConfirmPopup.instance()
	instance.type = 1
	instance.source = self
	add_child(instance)
	instance.popup_centered()
	instance.connect("confirmed", self, "_on_ConfirmPopup_confirmed", [], CONNECT_ONESHOT)
	release_focus()


func _on_ConfirmPopup_confirmed(event: InputEvent) -> void:
	# Update save value
	var current: Dictionary = ggsManager.settings_data[str(setting_index)]["current"]
	if event is InputEventJoypadMotion:
		current["value"] = event.axis_value
		current["axis"] = event.axis
	else:
		current["value"] = event.button_index
		if current.has("axis"):
			current.erase("axis")
	
	ggsManager.save_settings_data()
	
	# Update display value
	if event is InputEventJoypadMotion:
		use_axis_icon(event.axis_value, event.axis)
	else:
		use_button_icon(event.button_index)
	
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


func _get_axis_dir_string(axis: int, value: int) -> String:
	var result: String
	if axis == JOY_AXIS_0 or axis == JOY_AXIS_2:
		if value < 0:
			result = "left"
		else:
			result = "right"
	if axis == JOY_AXIS_1 or axis == JOY_AXIS_3:
		if value < 0:
			result = "up"
		else:
			result = "down"
	
	return result
