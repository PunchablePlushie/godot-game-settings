@tool
extends ggsBaseSelectList


func _ready() -> void:
	base_items = ggsInputHelper.get_input_map().keys()
	clear()
	create_from_arr(base_items)
