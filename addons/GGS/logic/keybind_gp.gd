extends Node
# value: int
#	Button Index/Axis Value
# action_name
#	Name of the action that'll be affected
# axis
#	Which gamepad axis/stick is being used (left or right) and which direction
#	it is (horizontal or vertical). Set this to -1 if the default keybind is not
#	a stick.


func main(value: Dictionary) -> void:
	var target_action: String = value["action_name"]
	var action_list: Array = InputMap.get_action_list(target_action)
	var new_event: InputEvent
	
	# Choose the correct event type
	var prev_event: InputEvent = GGSUtils.array_find_type(action_list, "InputEventJoypadButton") as InputEventJoypadButton
	
	if prev_event == null:
		prev_event = GGSUtils.array_find_type(action_list, "InputEventJoypadMotion") as InputEventJoypadMotion
	
	# Create the correct event type
	var prev_event_class: String = prev_event.get_class()
	if not value.has("axis"):
		new_event = InputEventJoypadButton.new() as InputEventJoypadButton
		new_event.button_index = value["value"]
	else:
		new_event = InputEventJoypadMotion.new() as InputEventJoypadMotion
		new_event.axis = value["axis"]
		new_event.axis_value = value["value"]

	InputMap.action_erase_event(target_action, prev_event)
	InputMap.action_add_event(target_action, new_event)
