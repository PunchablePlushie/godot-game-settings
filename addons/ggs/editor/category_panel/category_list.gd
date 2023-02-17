@tool
extends Tree

var root: TreeItem

@onready var CMenu: PopupMenu = $ContextMenu


func _ready() -> void:
	item_activated.connect(_on_item_activated)
	item_mouse_selected.connect(_on_item_mouse_selected)
	
	_reload_items()


func _reload_items() -> void:
	clear()
	root = create_item()
	
	for item in GGS.data.category_order:
		add_item(item)


func add_item(category: ggsCategory) -> void:
	var created_item: TreeItem = create_item(root)
	created_item.set_text(0, category.name)
	created_item.set_metadata(0, category)


func remove_item(item: TreeItem) -> void:
	item.free()
	_update_item_order()


func _update_item_order() -> void:
	var new_order: Array[ggsCategory]
	for child in root.get_children():
		var category_obj: ggsCategory = child.get_metadata(0)
		new_order.append(category_obj)
	
	GGS.data.update_category_order(new_order)


### Drag and Drop

func _get_drag_data(at_position: Vector2) -> Variant:
	var data: TreeItem = get_item_at_position(at_position)
	
	var preview: Button = Button.new()
	preview.flat = true
	preview.text = data.get_text(0)
	set_drag_preview(preview)
	
	return data


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if get_item_at_position(at_position) == null:
		return false
	else:
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


### Renaming

func _on_item_activated() -> void:
	var selected_item: TreeItem = get_selected()
	selected_item.set_editable(0, true)
	selected_item.select(0)
	edit_selected()


### Context Menu

func _on_item_mouse_selected(pos: Vector2, mouse_btn: int) -> void:
	var category: ggsCategory = get_item_at_position(pos).get_metadata(0)
	GGS.category_selected.emit(category)
	
	if not mouse_btn == MOUSE_BUTTON_RIGHT:
		return
	
	CMenu.position = DisplayServer.mouse_get_position()
	CMenu.popup()
