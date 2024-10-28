@tool
extends ggsSetting
class_name settingInput
## Changes the input binding of a specific input action defined in the
## Input Map.

## The target action from the [InputMap].
var action: String

## The target event of [member action].
var event_idx: int: set = _set_event_idx

var _input_helper: ggsInputHelper = ggsInputHelper.new()


func _init() -> void:
	value_type = TYPE_ARRAY
	default = []
	section = "input"
	read_only_properties = ["default", "type", "value_type",
		"value_hint", "value_hint_string"]


func _get_property_list() -> Array:
	return [
		{
			"name": "action",
			"type": TYPE_STRING,
			"usage": get_property_usage("action"),
		},
		{
			"name": "event_idx",
			"type": TYPE_INT,
			"usage": get_property_usage("event_index"),
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(_action_get_events()),
		},
	]


func _set_event_idx(value: int) -> void:
	event_idx = value

	var input_map: Dictionary = _input_helper.get_input_map()
	var target_event: InputEvent = input_map[action][event_idx]
	default = _input_helper.serialize_event(target_event)


func apply(value: Array) -> void:
	var event: InputEvent = _input_helper.deserialize_event(value)

	var new_events: Array[InputEvent] = InputMap.action_get_events(action)
	new_events.remove_at(event_idx)
	new_events.insert(event_idx, event)

	InputMap.action_erase_events(action)
	for input_event: InputEvent in new_events:
		InputMap.action_add_event(action, input_event)

	GGS.setting_applied.emit(key, value)


func _action_get_events() -> PackedStringArray:
	var input_map: Dictionary = _input_helper.get_input_map()

	var events: PackedStringArray
	if action.is_empty():
		return []

	for event: InputEvent in input_map[action]:
		var event_text: String = _input_helper.event_get_text(event)
		events.append(event_text)

	return events
