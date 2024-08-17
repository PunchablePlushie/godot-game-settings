@tool
extends ItemList
class_name ggsItemList
## A regular [ItemList] with a QoL methods.

## Holds all items of the unfiltered list. Used to return the list
## back to its unfiltered state without reloading it from the disc.
var unfiltered_list: PackedStringArray


## Creates the list from an array. If [param is_filtered] is true
## the new list is treated as a filtered list of the previous one.
func create_from_arr(list: PackedStringArray, is_filtered: bool = false) -> void:
	if not is_filtered:
		unfiltered_list = list
	
	clear()
	for item in list:
		add_item(item)


## Filters out all items that don't begin with [param filter].
func filter_list(filter: String) -> void:
	var _filter_: String = filter.to_lower()
	if _filter_.is_empty():
		create_from_arr(unfiltered_list)
		return
	
	var list: PackedStringArray
	for idx in item_count:
		var item_text: String = get_item_text(idx)
		if item_text.begins_with(_filter_):
			list.append(item_text)
	
	create_from_arr(list, true)
