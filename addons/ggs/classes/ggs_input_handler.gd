@tool
extends RefCounted
class_name ggsInputHandler

enum GPDevice {XBOX, PS, SWITCH, OTHER}

const MOUSE_INPUT: PackedStringArray = [
	"lmb", "rmb", "mmb", "mw up", "mw down", "mw left", "mw right", "mb1", "mb2"
]

const GP_BTN_INPUT: PackedStringArray = [
	"bot", "right", "left", "top", "back", "guide", "start",
	"left_stick", "right_stick", "left_shoulder", "right_shoulder",
	"dup", "ddown", "dleft", "dright", "misc", "pad1", "pad2", "pad3", "pad4",
	"touch"
]

const GP_MOTION_INPUT_VALUES: PackedStringArray = [
	"ls_left", "ls_right", "ls_up", "ls_down", "rs_left", "rs_right",
	"rs_up", "rs_down", "left_trigger", "right_trigger"
]

const GP_MOTION_INPUT: Array[Dictionary] = [
	{"-": "ls_left", "+": "ls_right"},
	{"-": "ls_up", "+": "ls_down"},
	{"-": "rs_left", "+": "rs_right"},
	{"-": "rs_up", "+": "rs_down"},
	{"+": "left_trigger"}, {"+": "right_trigger"}
]

const GP_DEVICES: Dictionary = {
	"XInput Gamepad": GPDevice.XBOX,
	"Xbox Series Controller": GPDevice.XBOX,
	"Sony DualSense": GPDevice.PS,
	"PS5 Controller": GPDevice.PS,
	"PS4 Controller": GPDevice.PS,
	"Switch": GPDevice.SWITCH,
}

const GP_XBOX_LABELS: PackedStringArray = [
	"A", "B", "X", "Y", "Back", "Home", "Start", "L", "R", "LB", "RB",
	"DPad Up", "DPad Down", "DPad Left", "DPad Right", "Share"
]

const GP_PS_LABELS: PackedStringArray = [
	"Cross", "Circle", "Square", "Triangle", "Select", "PS", "Start", "L3", "R3",
	"L1", "R1", "DPad Up", "DPad Down", "DPad Left", "DPad Right", "Microphone"
]

const GP_SWITCH_LABELS: PackedStringArray = [
	"B", "A", "Y", "X", "Minus", "", "Plus", "", "", "", "",
	"DPad Up", "DPad Down", "DPad Left", "DPad Right", "Capture"
]

const GP_OTHER_LABELS: PackedStringArray = [
	"Down Btn", "Right Btn", "Up Btn", "Left Btn", "Back", "Guide", "Start",
	"Left Stick", "Right Stick", "Left Shoulder", "Right Shoulder",
	"DPad Up", "DPad Down", "DPad Left", "DPad Right", "Microphone"
]

const GP_MOTION_LABELS: Array[Dictionary] = [
	{"-": "LStick Left", "+": "LStick Right"},
	{"-": "LStick Up", "+": "LStick Down"},
	{"-": "RStick Left", "+": "RStick Right"},
	{"-": "RStick Up", "+": "RStick Down"},
	{"+": "Left Trigger"}, {"+": "Right Trigger"}
]


func parse_input_string(string: String) -> InputEvent:
	var elements: PackedStringArray = string.split(",")
	var modifiers: PackedStringArray = elements.slice(0, -1)
	var key: String = elements[-1]
	
	if _is_mouse_input(key):
		return _create_mouse_input(modifiers, key)
	
	if _is_gamepad_input(key):
		return _create_gp_input(key)
	
	return _create_kb_input(modifiers, key)


func get_input_string_from_event(event: InputEvent) -> String:
	if event is InputEventKey:
		return _get_input_string_from_kb(event)
	
	if event is InputEventMouseButton:
		return _get_input_string_from_mouse(event)
	
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return _get_input_string_from_gamepad(event)
	
	return ""


func input_already_exists(event: InputEvent, self_action: String) -> Array:
	for action in InputMap.get_actions():
		if action.begins_with("ui_"):
			continue
		
		if action == self_action:
			continue
		
		if InputMap.action_has_event(action, event):
			return [true, action]
	
	return [false, ""]


### Keyboard

func _create_kb_input(modifiers: PackedStringArray, key: String) -> InputEventKey:
	var event: InputEventKey = InputEventKey.new()
	
	event.shift_pressed = modifiers.has("shift")
	event.alt_pressed = modifiers.has("alt")
	event.ctrl_pressed = modifiers.has("ctrl")
	
	event.physical_keycode = OS.find_keycode_from_string(key.capitalize())
	
	return event


func _get_input_string_from_kb(event: InputEventKey) -> String:
	var elements: PackedStringArray
	
	if event.shift_pressed:
		elements.append("shift")
	if event.alt_pressed:
		elements.append("alt")
	if event.ctrl_pressed:
		elements.append("ctrl")
	
	var key: String = OS.get_keycode_string(event.get_physical_keycode()).to_lower()
	elements.append(key)
	
	return ",".join(elements)


### Mouse

func get_mouse_event_string_abbr(event: InputEventMouseButton) -> String:
	var modifiers: String = _get_modifier_string(event)
	var btn: String = MOUSE_INPUT[event.button_index].to_upper()
	var result: String = "%s"%btn if modifiers.is_empty() else "%s+%s"%[modifiers, btn]
	return result


func _get_modifier_string(event: InputEventWithModifiers) -> String:
	var result: PackedStringArray
	
	if event.shift_pressed:
		result.append("Shift")
	if event.alt_pressed:
		result.append("Alt")
	if event.ctrl_pressed:
		result.append("Ctrl")
	
	return "+".join(result)


func _create_mouse_input(modifiers: PackedStringArray, key: String) -> InputEventMouseButton:
	var event: InputEventMouseButton = InputEventMouseButton.new()
	
	event.shift_pressed = modifiers.has("shift")
	event.alt_pressed = modifiers.has("alt")
	event.ctrl_pressed = modifiers.has("ctrl")
	
	event.button_index = MOUSE_INPUT.find(key) + 1
	
	return event


func _get_input_string_from_mouse(event: InputEventMouseButton) -> String:
	var elements: PackedStringArray
	
	if event.shift_pressed:
		elements.append("shift")
	if event.alt_pressed:
		elements.append("alt")
	if event.ctrl_pressed:
		elements.append("ctrl")
	
	var btn: String = MOUSE_INPUT[event.button_index]
	elements.append(btn)
	
	return ",".join(elements)


func _is_mouse_input(key: String) -> bool:
	return MOUSE_INPUT.has(key)


### Gamepad

func get_gp_event_string(event: InputEvent) -> String:
	var device_name: String = Input.get_joy_name(event.device)
	var device_type = _get_gp_device_type(device_name)
	
	if event is InputEventJoypadButton:
		match device_type:
			GPDevice.XBOX:
				return GP_XBOX_LABELS[event.button_index]
			GPDevice.PS:
				return GP_PS_LABELS[event.button_index]
			GPDevice.SWITCH:
				return GP_SWITCH_LABELS[event.button_index]
			GPDevice.OTHER:
				return GP_OTHER_LABELS[event.button_index]
	
	var axis_value: String = "-" if event.axis_value < 0 else "+"
	return GP_MOTION_LABELS[event.axis][axis_value]


func _get_gp_device_type(name: String) -> int:
	if GP_DEVICES.has(name):
		return GP_DEVICES[name]
	else:
		return GPDevice.OTHER


func _create_gp_input(key: String) -> InputEvent:
	var event: InputEvent
	
	var is_motion: bool = GP_MOTION_INPUT_VALUES.has(key)
	if is_motion:
		event = InputEventJoypadMotion.new()
		
		if key == "left_trigger":
			event.axis = JOY_AXIS_TRIGGER_LEFT
			event.axis_value = 1
		elif key == "right_trigger":
			event.axis = JOY_AXIS_TRIGGER_RIGHT
			event.axis_value = 1
		else:
			var elements: PackedStringArray = key.split("_")
			var stick: String = elements[0]
			var dir: String = elements[1]
			
			if stick == "ls":
				if dir == "left" or dir == "right":
					event.axis = JOY_AXIS_LEFT_X
				else:
					event.axis = JOY_AXIS_LEFT_Y
			else:
				if dir == "left" or dir == "right":
					event.axis = JOY_AXIS_RIGHT_X
				else:
					event.axis = JOY_AXIS_RIGHT_Y
			
			if dir == "left" or dir == "up":
				event.axis_value = -1
			else:
				event.axis_value = 1
	else:
		event = InputEventJoypadButton.new()
		event.button_index = GP_BTN_INPUT.find(key)
	
	return event


func _get_input_string_from_gamepad(event: InputEvent) -> String:
	if event is InputEventJoypadButton:
		return GP_BTN_INPUT[event.button_index]
	else:
		var axis_value: String = "-" if event.axis_value < 0 else "+"
		return GP_MOTION_INPUT[event.axis][axis_value]


func _is_gamepad_input(key: String) -> bool:
	return GP_BTN_INPUT.has(key) or GP_MOTION_INPUT_VALUES.has(key)
