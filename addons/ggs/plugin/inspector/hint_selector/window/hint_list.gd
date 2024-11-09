@tool
extends ggsBaseSelectList


func init_list(base_list: PackedStringArray) -> void:
	base_items = base_list
	create_from_arr(base_list)
