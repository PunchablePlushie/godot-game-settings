@tool
extends ggsSetting
class_name ggsInputSetting

const ALLOWED_EVENTS: String = "InputEventKey,InputEventMouseButton,InputEventJoypadButton,InputEventJoypadMotion"

enum Type {KEYBOARD, GAMEPAD}
var type: Type

var action: String
var event_index: int
var default_as_event: InputEvent
var current_as_event: InputEvent


func _get_property_list() -> Array:
	var read_only: PropertyUsageFlags =  PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
	
	var properties: Array
	properties.append_array([
		{"name": "action", "type": TYPE_STRING, "usage": read_only},
		{"name": "event_index", "type": TYPE_INT, "usage": read_only},
		{"name": "default_as_event", "type": TYPE_OBJECT, "usage": read_only, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": ALLOWED_EVENTS},
		{"name": "current_as_event", "type": TYPE_OBJECT, "usage": PROPERTY_USAGE_DEFAULT, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": ALLOWED_EVENTS},
	])
	
	return properties


func _init() -> void:
	read_only_values = true
	value_type = TYPE_INT
	default = -1


func get_current() -> Variant:
	var save_file: ggsSaveFile = ggsSaveFile.new()
	if save_file.has_section_key(category, name):
		return save_file.get_value(category, name)
	else:
		return default


func apply(value: String) -> void:
	return
	var input_helper: ggsInputHelper = ggsInputHelper.new()
	var new_input: InputEvent = input_helper.get_event_from_string(value)
	
	for event in InputMap.action_get_events(action):
		if _event_is_type(event):
			InputMap.action_erase_event(action, event)
	
	InputMap.action_add_event(action, new_input)


func _set_event_input_id(event: InputEvent, value: int) -> void:
	if event is InputEventKey:
		event.keycode = value
	
	if event is InputEventMouseButton or event is InputEventJoypadButton:
		event.button_index = value
	
	if event is InputEventJoypadMotion:
		event.axis = value


func _get_event_input_id(event: InputEvent) -> int:
	if event is InputEventKey:
		return event.keycode
	
	if event is InputEventMouseButton or event is InputEventJoypadButton:
		return event.button_index
	
	if event is InputEventJoypadMotion:
		return event.axis
	
	return -1


func _event_is_type(event: InputEvent) -> bool:
	match type:
		Type.KEYBOARD:
			return (event is InputEventKey) or (event is InputEventMouseButton)
		Type.GAMEPAD:
			return (event is InputEventJoypadButton) or (event is InputEventJoypadMotion)
		_:
			return false
