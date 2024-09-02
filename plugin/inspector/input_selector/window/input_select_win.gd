@tool
extends ggsBaseSelectWin

signal input_confirmed(action: String)


func _confirm_selection(selection: String) -> void:
	input_confirmed.emit(selection)
	hide()


func _on_confirmed() -> void:
	var item_idx = get_selected_item_idx()
	var item: String = List.get_item_text(item_idx)
	_confirm_selection(item)


func _on_FilterField_text_submitted(submitted_text: String) -> void:
	if field_value_is_valid:
		var item: String = List.get_item_text(0)
		_confirm_selection(item)


func _on_List_item_activated(index: int) -> void:
	var item: String = List.get_item_text(index)
	_confirm_selection(item)
