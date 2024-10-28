@tool
extends ItemList
class_name ggsBaseSelectList

var base_items: PackedStringArray


func _init() -> void:
	max_columns = 3
	fixed_column_width = 180


func filter(input: String) -> void:
	clear()

	if input.is_empty():
		create_from_arr(base_items)
		return

	var types_filtered: Array = Array(base_items).filter(_filter_method.bind(input))
	create_from_arr(PackedStringArray(types_filtered))


func create_from_arr(arr: PackedStringArray) -> void:
	clear()
	for action: String in arr:
		add_item(action)


func _filter_method(element: String, input: String) -> bool:
	var element_lowered: String = element.to_lower()
	var input_lowered: String = input.to_lower()
	return element_lowered.begins_with(input_lowered)
