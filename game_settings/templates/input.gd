@tool
extends ggsSetting
class_name ggsInputSetting

enum Type {INVALID, KEYBOARD, MOUSE, GP_BTN, GP_MOTION}

var action: String
var event_index: int
var type: Type = Type.INVALID
var default_as_event: InputEvent: set = set_default_as_event
var current_as_event: InputEvent: set = set_current_as_event


func _init() -> void:
	read_only_values = true
	value_type = TYPE_ARRAY
	default = [-1, -1]


func _get_property_list() -> Array:
	var read_only: int =  PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
	var allowed_event: String = _get_allowed_event_types()
	
	var properties: Array
	properties.append_array([
		{"name": "action", "type": TYPE_STRING, "usage": read_only},
		{"name": "event_index", "type": TYPE_INT, "usage": read_only},
		{"name": "type", "type": TYPE_INT, "usage": PROPERTY_USAGE_STORAGE, "hint": PROPERTY_HINT_ENUM, "hint_string": "None,Keyboard,Mouse,Gamepad Button,Gamepad Motion"},
		{"name": "default_as_event", "type": TYPE_OBJECT, "usage": read_only, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": allowed_event},
		{"name": "current_as_event", "type": TYPE_OBJECT, "usage": read_only if type == Type.INVALID else PROPERTY_USAGE_DEFAULT, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": allowed_event},
	])
	
	return properties


func _get_allowed_event_types() -> String:
	if type == Type.KEYBOARD or type == Type.MOUSE:
		return "InputEventKey,InputEventMouseButton"
	
	if type == Type.GP_BTN or type == Type.GP_MOTION:
		return "InputEventJoypadButton,InputEventJoypadMotion"
	
	return ""


func _event_get_id(event: InputEvent) -> int:
	if event is InputEventKey:
		if event.physical_keycode == 0:
			return -1
		
		return event.physical_keycode | event.get_modifiers_mask()
	
	if event is InputEventMouseButton:
		return event.button_index | event.get_modifiers_mask()
	
	if event is InputEventJoypadButton:
		return event.button_index
	
	if event is InputEventJoypadMotion:
		return event.axis
	
	return -1


func _event_get_type(event: InputEvent) -> Type:
	if event is InputEventKey:
		return Type.KEYBOARD
	
	if event is InputEventMouseButton:
		return Type.MOUSE
	
	if event is InputEventJoypadButton:
		return Type.GP_BTN
	
	if event is InputEventJoypadMotion:
		return Type.GP_MOTION
	
	return Type.INVALID


### Updating Current and Default

func set_default_as_event(value: InputEvent) -> void:
	default_as_event = value
	
	if not Engine.is_editor_hint():
		return
	
	type = _event_get_type(value)
	default = [type, _event_get_id(value)]
	ggsUtils.get_editor_interface().inspect_object.call_deferred(self)


func set_current_as_event(value: InputEvent) -> void:
	current_as_event = value
	
	if not Engine.is_editor_hint():
		return
	
	type = _event_get_type(current_as_event)
	current = [type, _event_get_id(value)]
	if value != null:
		value.changed.connect(_on_current_event_changed)


func _on_current_event_changed() -> void:
	current = [type, _event_get_id(current_as_event)]


### Applying

func apply(value: Array) -> void:
	if value.is_empty() or value[0] == -1 or value[1] == -1:
		return
	
	var event: InputEvent = _event_create_from_type(value[0])
	_event_set_id(event, value[1])
	
	var action_events: Array[InputEvent] = InputMap.action_get_events(action)
	action_events.remove_at(event_index)
	action_events.insert(event_index, event)
	
	InputMap.action_erase_events(action)
	for _event_ in action_events:
		InputMap.action_add_event(action, _event_)


func _event_create_from_type(_type_: Type) -> InputEvent:
	match _type_:
		Type.KEYBOARD:
			return InputEventKey.new()
		Type.MOUSE:
			return InputEventMouseButton.new()
		Type.GP_BTN:
			return InputEventJoypadButton.new()
		Type.GP_MOTION:
			return InputEventJoypadMotion.new()
		_:
			return null


func _event_set_id(event: InputEvent, id: int) -> void:
	if event is InputEventKey:
		event.physical_keycode = id & (~KEY_MODIFIER_MASK)
		_event_set_modifiers(event, id)
	
	if event is InputEventMouseButton:
		event.button_index = id & (~KEY_MODIFIER_MASK)
		_event_set_modifiers(event, id)
	
	if event is InputEventJoypadButton:
		event.button_index = id
	
	if event is InputEventJoypadMotion:
		event.axis = id


func _event_set_modifiers(event: InputEventWithModifiers, modifier_mask: int) -> void:
	event.shift_pressed = bool(modifier_mask & KEY_MASK_SHIFT)
	event.ctrl_pressed = bool(modifier_mask & KEY_MASK_CTRL)
	event.alt_pressed = bool(modifier_mask & KEY_MASK_ALT)
