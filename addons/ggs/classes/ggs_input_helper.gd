@tool
extends RefCounted
class_name ggsInputHelper

var keywords: Dictionary = {
	"mouse": [
		"lmb", "rmb", "mmb", "mw_up", "mw_down", "mw_left", "mw_right", "mb1", "mb2"
	],
	
	"gamepad_btn": [
		"bbot", "bright", "bleft", "btop", "back", "guide", "start",
		"left_stick", "right_stick", "left_shoulder", "right_shoulder",
		"dup", "ddown", "dleft", "dright", "misc", "pad1", "pad2", "pad3", "pad4",
		"touch"
	],
	
	"gamepad_motion": [
		{"-": "ls_left", "+": "ls_right"},
		{"-": "ls_up", "+": "ls_down"},
		{"-": "rs_left", "+": "rs_right"},
		{"-": "rs_up", "+": "rs_down"},
		{"+": "left_trigger"},
		{"+": "right_trigger"}
	],
	
	"gamepad_motion_no_direction": [
		"ls_left", "ls_right", "ls_up", "ls_down", "rs_left", "rs_right",
		"rs_up", "rs_down", "left_trigger", "right_trigger"
	],
}

var gamepad_devices: Dictionary = {
	"XInput Gamepad": "xbox",
	"Xbox Series Controller": "xbox",
	"Sony DualSense": "ps",
	"PS5 Controller": "ps",
	"PS4 Controller": "ps",
	"Switch": "switch",
} 

var gamepad_labels: Dictionary = {
	"xbox": [
		"A", "B", "X", "Y", "Back", "Home", "Start", "L", "R", "LB", "RB",
		"DPad Up", "DPad Down", "DPad Left", "DPad Right", "Share"
	],
	
	"ps": [
		"Cross", "Circle", "Square", "Triangle", "Select", "PS", "Start",
		"L3", "R3", "L1", "R1", "DPad Up", "DPad Down", "DPad Left",
		"DPad Right", "Microphone"
	],
	
	"switch": [
		"B", "A", "Y", "X", "Minus", "", "Plus", "", "", "", "",
		"DPad Up", "DPad Down", "DPad Left", "DPad Right", "Capture"
	],
	
	"other": [
		"A", "B", "X", "Y", "Back", "Home", "Start", "L", "R", "LB", "RB",
		"DPad Up", "DPad Down", "DPad Left", "DPad Right", "Share",
		"Paddle 1", "Paddle 2", "Paddle 3", "Paddle 4", "Touch"
	],
	
	"motion": [
		{"-": "LStick Left", "+": "LStick Right"},
		{"-": "LStick Up", "+": "LStick Down"},
		{"-": "RStick Left", "+": "RStick Right"},
		{"-": "RStick Up", "+": "RStick Down"},
		{"+": "Left Trigger"},
		{"+": "Right Trigger"}
	],
}


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
	
	if event is InputEventJoypadButton:
		return _get_gp_btn_event_as_text(event)
	
	if event is InputEventJoypadMotion:
		return _get_gp_motion_event_as_text(event)
	
	return ""


func get_event_as_icon(event: InputEvent, icon_db: ggsGPIconDB) -> Texture2D:
	if event is InputEventJoypadButton:
		return _get_gp_btn_event_as_icon(event, icon_db)
	
	if event is InputEventJoypadMotion:
		return _get_gp_motion_event_as_icon(event, icon_db)
	
	return null


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
		result.append("shift")
	if event.alt_pressed:
		result.append("alt")
	if event.ctrl_pressed:
		result.append("ctrl")
	
	if use_plus:
		var index: int = 0
		for element in result:
			result.set(index, element.capitalize())
			index += 1
		
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
	var result: String = "%s"%key if modifiers.is_empty() else "%s,%s"%[modifiers, key]
	
	return result


### Mouse

func _get_mouse_event_as_text(event: InputEventMouseButton) -> String:
	var modifiers: String = _get_modifiers_string(event, true)
	var btn: String = keywords["mouse"][event.button_index - 1].to_upper()
	var result: String = "%s"%btn if modifiers.is_empty() else "%s+%s"%[modifiers, btn]
	return result


func _create_mouse_event(modifiers: PackedStringArray, btn: String) -> InputEventMouseButton:
	var event: InputEventMouseButton = InputEventMouseButton.new()
	event = _set_event_modifiers(event, modifiers)
	event.button_index = keywords["mouse"].find(btn) + 1
	
	return event


func _get_mouse_event_string(event: InputEventMouseButton) -> String:
	var modifiers: String = _get_modifiers_string(event)
	var btn: String = keywords["mouse"][event.button_index - 1]
	var result: String = "%s"%btn if modifiers.is_empty() else "%s,%s"%[modifiers, btn]
	
	return result


func _string_is_for_mouse(btn: String) -> bool:
	return keywords["mouse"].has(btn)



### Gamepad

func _get_gp_btn_event_as_text(event: InputEventJoypadButton) -> String:
	var device_name: String = Input.get_joy_name(event.device)
	device_name = _get_joy_name_shortened(device_name)
	return gamepad_labels[device_name][event.button_index]


func _get_gp_motion_event_as_text(event: InputEventJoypadMotion) -> String:
	var device_name: String = Input.get_joy_name(event.device)
	device_name = _get_joy_name_shortened(device_name)
	
	var axis_value: String = "-" if event.axis_value < 0 else "+"
	return gamepad_labels["motion"][event.axis][axis_value]


func _get_gp_btn_event_as_icon(event: InputEventJoypadButton, icon_db: ggsGPIconDB) -> Texture2D:
	var device_name: String = Input.get_joy_name(event.device)
	device_name = _get_joy_name_shortened(device_name)
	
	var event_string: String = _get_gp_event_string(event)
	var icon: Texture2D = icon_db.get_btn_texture(device_name, event_string)
	
	return icon


func _get_gp_motion_event_as_icon(event: InputEventJoypadMotion, icon_db: ggsGPIconDB) -> Texture2D:
	var device_name: String = Input.get_joy_name(event.device)
	device_name = _get_joy_name_shortened(device_name)
	
	var event_string: String = _get_gp_event_string(event)
	var icon: Texture2D = icon_db.get_motion_texture(device_name, event_string)
	
	return icon


func _get_joy_name_shortened(name: String) -> String:
	if gamepad_devices.has(name):
		return gamepad_devices[name]
	else:
		return "other"


func _create_gp_event(btn: String) -> InputEvent:
	var event: InputEvent
	
	var is_motion: bool = keywords["gamepad_motion_no_direction"].has(btn)
	if is_motion:
		event = _create_gp_motion_event(btn)
	else:
		event = InputEventJoypadButton.new()
		event.button_index = keywords["gamepad_btn"].find(btn)
	
	return event


func _create_gp_motion_event(btn: String) -> InputEventJoypadMotion:
	var event: InputEventJoypadMotion = InputEventJoypadMotion.new()
	
	match btn:
		"left_trigger":
			event.axis = JOY_AXIS_TRIGGER_LEFT
			event.axis_value = 1
		"right_trigger":
			event.axis = JOY_AXIS_TRIGGER_RIGHT
			event.axis_value = 1
		_:
			var elements: PackedStringArray = btn.split("_")
			var stick: String = elements[0]
			var dir: String = elements[1]
			
			# Determine Axis
			match stick:
				"ls":
					match dir:
						"left", "right":
							event.axis = JOY_AXIS_LEFT_X
						"up", "down":
							event.axis = JOY_AXIS_LEFT_Y
				"rs":
					match dir:
						"left", "right":
							event.axis = JOY_AXIS_RIGHT_X
						"up", "down":
							event.axis = JOY_AXIS_RIGHT_Y
			
			# Determine Axis Value
			match dir:
				"left", "up":
					event.axis_value = -1
				"right", "down":
					event.axis_value = 1
	
	return event


func _get_gp_event_string(event: InputEvent) -> String:
	if event is InputEventJoypadButton:
		return keywords["gamepad_btn"][event.button_index]
	else:
		var axis_value: String = "-" if event.axis_value < 0 else "+"
		return keywords["gamepad_motion"][event.axis][axis_value]


func _string_is_for_gp(btn: String) -> bool:
	return keywords["gamepad_btn"].has(btn) or keywords["gamepad_motion_no_direction"].has(btn)
