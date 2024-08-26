@tool
extends ItemList

var _actions: PackedStringArray


func _ready() -> void:
	_actions = ggsInputHelper.get_input_map().keys()
	clear()
	_create_from_arr(_actions)


func filter(input: String) -> void:
	clear()
	
	if input.is_empty():
		_create_from_arr(_actions)
		return
	
	var types_filtered: Array = Array(_actions).filter(_filter_method.bind(input))
	_create_from_arr(PackedStringArray(types_filtered))


func _create_from_arr(arr: PackedStringArray) -> void:
	for action: String in arr:
		add_item(action)


func _filter_method(element: String, input: String) -> bool:
	var element_lowered: String = element.to_lower()
	var input_lowered: String = input.to_lower()
	return element_lowered.begins_with(input_lowered)
