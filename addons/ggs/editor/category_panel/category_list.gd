@tool
extends ggsTree

@onready var CMenu: PopupMenu = $ContextMenu


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	item_activated.connect(_on_item_activated)
	item_mouse_selected.connect(_on_item_mouse_selected)
	
	_load_list()


func _load_list() -> void:
	clear()
	root = create_item()
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	for item in data.category_order:
		add_item(item)


func add_item(category: ggsCategory) -> void:
	var created_item: TreeItem = create_item(root)
	created_item.set_text(0, category.name)
	created_item.set_metadata(0, category)


func remove_item(item: TreeItem) -> void:
	GGS.category_selected.emit(null)
	item.free()
	_update_item_order()


func _on_item_selected() -> void:
	var selected_category: ggsCategory = get_selected().get_metadata(0)
	GGS.category_selected.emit(selected_category)


### Drag and Drop

func _update_item_order() -> void:
	var new_order: Array[ggsCategory]
	for child in root.get_children():
		var category_obj: ggsCategory = child.get_metadata(0)
		new_order.append(category_obj)
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	data.update_category_order(new_order)


### Context Menu

func _on_item_mouse_selected(pos: Vector2, mouse_btn: int) -> void:
	var category: ggsCategory = get_item_at_position(pos).get_metadata(0)
	
	if not mouse_btn == MOUSE_BUTTON_RIGHT:
		return
	
	CMenu.position = DisplayServer.mouse_get_position()
	CMenu.popup()
