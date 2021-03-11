extends BaseSetting


func change(new_key: InputEventKey) -> void:
	var action_list: Array = InputMap.get_action_list(name)
	InputMap.action_erase_event(name, action_list[0])
	InputMap.action_add_event(name, new_key)
