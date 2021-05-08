extends Node
# value: int
#	Scancode
# action_name
#	Name of the action that'll be affected


func main(value: Dictionary) -> void:
	var target_action: String = value["action_name"]
	var action_list: Array = InputMap.get_action_list(target_action)
	var prev_event: InputEventKey = Utils.array_find_type(action_list, "InputEventKey")
	var new_event: InputEventKey = InputEventKey.new()
	new_event.scancode = value["value"]

	InputMap.action_erase_event(target_action, prev_event)
	InputMap.action_add_event(target_action, new_event)
