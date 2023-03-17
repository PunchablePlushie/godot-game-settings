@tool
extends RefCounted
class_name ggsInputHelper

enum GPDevice {XBOX, PS, SWITCH, OTHER}

var keywords: Dictionary = {
	"mouse": [
		"lmb", "rmb", "mmb", "mw_up", "mw_down", "mw_left", "mw_right", "mb1", "mb2"
	]
}

#const MOUSE_INPUT: PackedStringArray = [
#	"lmb", "rmb", "mmb", "mw up", "mw down", "mw left", "mw right", "mb1", "mb2"
#]

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


func get_event_from_string(string: String) -> InputEvent:
	var elements: PackedStringArray = string.split(",")
	var modifiers: PackedStringArray = elements.slice(0, -1)
	var main: String = elements[-1]
	
	if _string_is_for_mouse(main):
		return _create_mouse_event(modifiers, main)
	
	if _string_is_for_gp(main):
		return _create_gp_event(main)
	
	return _create_kb_event(modifiers, main)


func get_string_from_event(event: InputEvent) -> String:
	if event is InputEventKey:
		return _get_kb_event_string(event)
	
	if event is InputEventMouseButton:
		return _get_mouse_event_string(event)
	
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return _get_gp_event_string(event)
	
	return ""


func get_event_as_text(event: InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_keycode_string(event.get_physical_keycode_with_modifiers())
	
	if event is InputEventMouseButton:
		return _get_mouse_event_as_text(event)
	
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


func _get_modifiers_string(event: InputEventWithModifiers, use_plus: bool = false) -> String:
	var result: PackedStringArray
	
	if event.shift_pressed:
		result.append("Shift")
	if event.alt_pressed:
		result.append("Alt")
	if event.ctrl_pressed:
		result.append("Ctrl")
	
	if use_plus:
		return "+".join(result)
	else:
		return ",".join(result)


func _set_event_modifiers(event: InputEventWithModifiers, modifiers: PackedStringArray) -> InputEventWithModifiers:
	event.shift_pressed = modifiers.has("shift")
	event.alt_pressed = modifiers.has("alt")
	event.ctrl_pressed = modifiers.has("ctrl")
	return event


### Keyboard

func _create_kb_event(modifiers: PackedStringArray, key: String) -> InputEventKey:
	var event: InputEventKey = InputEventKey.new()
	event = _set_event_modifiers(event, modifiers)
	event.physical_keycode = OS.find_keycode_from_string(key.capitalize())
	
	return event


func _get_kb_event_string(event: InputEventKey) -> String:
	var modifiers: String = _get_modifiers_string(event)
	var key: String = OS.get_keycode_string(event.get_physical_keycode()).to_lower()
	
	return "%s,%s"%[modifiers, key]


### Mouse

func _get_mouse_event_as_text(event: InputEventMouseButton) -> String:
	var modifiers: String = _get_modifiers_string(event)
	var btn: String = keywords["mouse"][event.button_index].to_upper()
	var result: String = "%s"%btn if modifiers.is_empty() else "%s+%s"%[modifiers, btn]
	return result


func _create_mouse_event(modifiers: PackedStringArray, btn: String) -> InputEventMouseButton:
	var event: InputEventMouseButton = InputEventMouseButton.new()
	event = _set_event_modifiers(event, modifiers)
	event.button_index = keywords["mouse"].find(btn) + 1
	
	return event


func _get_mouse_event_string(event: InputEventMouseButton) -> String:
	var modifiers: String = _get_modifiers_string(event)
	var btn: String = keywords["mouse"][event.button_index]
	
	return "%s,%s"%[modifiers, btn]


func _string_is_for_mouse(key: String) -> bool:
	return keywords["mouse"].has(key)


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


func _create_gp_event(key: String) -> InputEvent:
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


func _get_gp_event_string(event: InputEvent) -> String:
	if event is InputEventJoypadButton:
		return GP_BTN_INPUT[event.button_index]
	else:
		var axis_value: String = "-" if event.axis_value < 0 else "+"
		return GP_MOTION_INPUT[event.axis][axis_value]


func _string_is_for_gp(key: String) -> bool:
	return GP_BTN_INPUT.has(key) or GP_MOTION_INPUT_VALUES.has(key)
