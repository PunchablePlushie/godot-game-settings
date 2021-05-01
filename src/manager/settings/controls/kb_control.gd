extends Node


# Input value is always an array: [action_name: String, event_scancode: int]
func main(value: Array) -> void:
	var target_action: String = value[0]
	var action_list: Array = InputMap.get_action_list(target_action)
	var prev_event: InputEventKey = ggsManager.array_find_type(action_list, "InputEventKey")
	var new_event: InputEventKey = InputEventKey.new()
	new_event.scancode = value[1]

	InputMap.action_erase_event(target_action, prev_event)
	InputMap.action_add_event(target_action, new_event)
