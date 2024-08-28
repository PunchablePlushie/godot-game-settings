@tool
extends ggsBaseSelectWin

signal type_confirmed(type: Variant.Type)


func _confirm_selection(selection: Variant.Type) -> void:
	type_confirmed.emit(selection)
	hide()


func _on_confirmed() -> void:
	var item_idx = get_selected_item_idx()
	var item: String = List.get_item_text(item_idx)
	var hint_idx = ggsUtils.ALL_TYPES.find_key(item)
	_confirm_selection(hint_idx)


func _on_FilterField_text_submitted(submitted_text: String) -> void:
	if field_value_is_valid:
		var item: String = List.get_item_text(0)
		var idx: int = ggsUtils.ALL_TYPES.find_key(item)
		_confirm_selection(idx)


func _on_List_item_activated(index: int) -> void:
	var item: String = List.get_item_text(index)
	var idx: int = ggsUtils.ALL_TYPES.find_key(item)
	_confirm_selection(idx)
