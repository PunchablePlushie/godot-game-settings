@tool
extends Tree
class_name ggsTree

var root: TreeItem


### Drag and Drop

func _get_drag_data(at_position: Vector2) -> Variant:
	var data: TreeItem = get_item_at_position(at_position)
	
	var preview: Button = Button.new()
	preview.flat = true
	preview.text = data.get_text(0)
	set_drag_preview(preview)
	
	return data


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var target_item: TreeItem = get_item_at_position(at_position)
	
	if target_item == null:
		return false
	
	if data.get_tree() != target_item.get_tree():
		return false
	
	drop_mode_flags = DROP_MODE_INBETWEEN
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var shift: int = get_drop_section_at_position(at_position)
	var target: TreeItem = get_item_at_position(at_position)
	
	if shift == 1:
		data.move_after(target)
	else:
		data.move_before(target)
	
	_update_item_order()


func _update_item_order() -> void:  # virtual
	pass


### Renaming

func _on_item_activated() -> void:
	var selected_item: TreeItem = get_selected()
	selected_item.set_editable(0, true)
	selected_item.select(0)
	edit_selected()
