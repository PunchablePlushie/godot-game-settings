class_name BaseSetting
extends Node

export(String) var section: String
export(String) var key: String


## Finds the first item with a specific type in an array. Used for changing
# controls (gp_control.gd and kb_control.gd).
func array_find_type(array: Array, type: String) -> Object:
	for item in array:
		var item_class: String = item.get_class()
		if item_class == type:
			return item
		else:
			continue
	return null
