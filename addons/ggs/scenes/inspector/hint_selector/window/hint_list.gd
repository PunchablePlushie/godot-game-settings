@tool
extends ItemList

var _hints: PackedStringArray


func init_list(base_list: PackedStringArray) -> void:
	_hints = base_list
	_create_from_arr(base_list)


func filter(input: String) -> void:
	if input.is_empty():
		_create_from_arr(_hints)
		return
	
	var types_filtered: Array = Array(_hints).filter(_filter_method.bind(input))
	_create_from_arr(PackedStringArray(types_filtered))


func _create_from_arr(arr: PackedStringArray) -> void:
	clear()
	for hint: String in arr:
		add_item(hint)


func _filter_method(element: String, input: String) -> bool:
	var element_lowered: String = element.to_lower()
	var input_lowered: String = input.to_lower()
	return element_lowered.begins_with(input_lowered)
