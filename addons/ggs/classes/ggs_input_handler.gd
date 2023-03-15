@tool
extends RefCounted
class_name ggsInputHandler

const MOUSE_INPUT: PackedStringArray = [
	"lmb", "rmb", "mmb", "mw up", "mw down", "mw left", "mw right", "mb1", "mb2"
]


func parse_input_string(string: String) -> InputEvent:
	var elements: PackedStringArray = string.split(",")
	var modifiers: PackedStringArray = elements.slice(0, -1)
	var key: String = elements[-1]
	
	if _is_mouse_input(key):
		return _create_mouse_input(modifiers, key)
	
	return _create_kb_input(modifiers, key)


func get_input_string_from_event(event: InputEvent) -> String:
	if event is InputEventKey:
		return _get_input_string_from_kb(event)
	
	if event is InputEventMouseButton:
		return _get_input_string_from_mouse(event)
	
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
	var btn: String = _get_mouse_button_string_abbr(event)
	var result: String = "%s"%btn if modifiers.is_empty() else "%s+%s"%[modifiers, btn]
	return result


func _get_mouse_button_string_abbr(event: InputEventMouseButton) -> String:
	var result: String
	match event.button_index:
		MOUSE_BUTTON_NONE:
			result = ""
		MOUSE_BUTTON_LEFT:
			result = "LMB"
		MOUSE_BUTTON_RIGHT:
			result = "RMB"
		MOUSE_BUTTON_MIDDLE:
			result = "MMB"
		MOUSE_BUTTON_WHEEL_UP:
			result = "MW Up"
		MOUSE_BUTTON_WHEEL_DOWN:
			result = "MW Down"
		MOUSE_BUTTON_WHEEL_LEFT:
			result = "MW Left"
		MOUSE_BUTTON_WHEEL_RIGHT:
			result = "MW Right"
		MOUSE_BUTTON_XBUTTON1:
			result = "MB1"
		MOUSE_BUTTON_XBUTTON2:
			result = "MB2"
	
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
	
	var btn: String = _get_mouse_button_string_abbr(event).to_lower()
	elements.append(btn)
	
	return ",".join(elements)


func _is_mouse_input(key: String) -> bool:
	return MOUSE_INPUT.has(key)


