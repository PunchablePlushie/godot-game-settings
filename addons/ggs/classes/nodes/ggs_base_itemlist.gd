@tool
extends ItemList
class_name ggsBaseItemList

var unfiltered_list: PackedStringArray


func create_from_arr(list: PackedStringArray, is_filtered: bool = false) -> void:
	if not is_filtered:
		unfiltered_list = list
	
	clear()
	for item in list:
		add_item(item)


func filter_list(filter: String) -> void:
	create_from_arr(unfiltered_list)
	
	if filter.is_empty():
		return
	
	var _filter_: String = filter.to_lower()
	var list: PackedStringArray
	for idx in item_count:
		var item_text: String = get_item_text(idx)
		if item_text.begins_with(_filter_):
			list.append(item_text)
	
	create_from_arr(list, true)
