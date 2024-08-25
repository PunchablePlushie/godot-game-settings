@tool
extends ggsSetting
class_name settingInput
## Changes the input binding of a specific input action defined in the
## Input Map.

var action: String
var event_index: int
var type: ggsInputHelper.InputType = ggsInputHelper.InputType.INVALID

var _input_helper: ggsInputHelper = ggsInputHelper.new()


func _init() -> void:
	value_type = TYPE_ARRAY
	default = []
	section = "input"
	read_only_properties = ["default"]


func _get_property_list() -> Array:
	var input_map: Dictionary = ggsUtils.get_input_map()
	
	var helper = ggsInputHelper.new()
	var events: PackedStringArray
	if not action.is_empty():
		for event: InputEvent in input_map[action]:
			var event_text: String = helper.get_event_as_text(event)
			events.append(event_text)
	
	var hint_string: String = ",".join(events)
	var properties: Array
	properties.append_array([
		{
			"name": "action",
			"type": TYPE_STRING,
			"usage": get_property_usage("action"),
		},
		{
			"name": "event_index",
			"type": TYPE_INT,
			"usage": get_property_usage("event_index"),
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
		},
		{
			"name": "type",
			"type": TYPE_INT,
			"usage": get_property_usage("type"),
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "None,Keyboard,Mouse,Gamepad Button,Gamepad Motion",
		},
	])
	
	return properties


func apply(value: Array) -> void:
	if value.is_empty() or value[0] == -1 or value[1] == -1:
		return
	
	var event: InputEvent = _input_helper.create_event_from_type(value[0])
	_input_helper.set_event_id(event, value[1])
	
	var action_events: Array[InputEvent] = InputMap.action_get_events(action)
	action_events.remove_at(event_index)
	action_events.insert(event_index, event)
	
	InputMap.action_erase_events(action)
	for _event_ in action_events:
		InputMap.action_add_event(action, _event_)
