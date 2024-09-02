@tool
extends ggsSetting
class_name ggsInputSetting

var action: String
var event_index: int
var type: ggsInputHelper.InputType = ggsInputHelper.InputType.INVALID
var default_as_event: InputEvent: set = set_default_as_event
var current_as_event: InputEvent: set = set_current_as_event
var input_helper: ggsInputHelper = ggsInputHelper.new()


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
		{"name": "current_as_event", "type": TYPE_OBJECT, "usage": read_only if type == input_helper.InputType.INVALID else PROPERTY_USAGE_DEFAULT, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": allowed_event},
	])
	
	return properties


func update_current_as_event() -> void:
	var event: InputEvent = input_helper.create_event_from_type(current[0])
	input_helper.set_event_id(event, current[1])
	current_as_event = event


func _get_allowed_event_types() -> String:
	if type == input_helper.InputType.KEYBOARD or type == input_helper.InputType.MOUSE:
		return "InputEventKey,InputEventMouseButton"
	
	if type == input_helper.InputType.GP_BTN or type == input_helper.InputType.GP_MOTION:
		return "InputEventJoypadButton,InputEventJoypadMotion"
	
	return ""


### Updating Current and Default

func set_default_as_event(value: InputEvent) -> void:
	default_as_event = value
	
	if not Engine.is_editor_hint():
		return
	
	type = input_helper.get_event_type(value)
	default = [type, input_helper.get_event_id(value)]
	ggsUtils.get_editor_interface().inspect_object.call_deferred(self)


func set_current_as_event(value: InputEvent) -> void:
	current_as_event = value
	
	if not Engine.is_editor_hint():
		return
	
	type = input_helper.get_event_type(current_as_event)
	current = [type, input_helper.get_event_id(value)]
	if value != null:
		value.changed.connect(_on_current_event_changed)


func _on_current_event_changed() -> void:
	current = [type, input_helper.get_event_id(current_as_event)]


### Applying

func apply(value: Array) -> void:
	if value.is_empty() or value[0] == -1 or value[1] == -1:
		return
	
	var event: InputEvent = input_helper.create_event_from_type(value[0])
	input_helper.set_event_id(event, value[1])
	
	var action_events: Array[InputEvent] = InputMap.action_get_events(action)
	action_events.remove_at(event_index)
	action_events.insert(event_index, event)
	
	InputMap.action_erase_events(action)
	for _event_ in action_events:
		InputMap.action_add_event(action, _event_)

