extends LineEdit
class_name BaseInput

var saved: bool = false setget set_saved


func set_saved(value: bool) -> void:
	saved = value
	if saved:
		modulate = ggsManager.COL_GOOD
	else:
		modulate = ggsManager.COL_ERR
