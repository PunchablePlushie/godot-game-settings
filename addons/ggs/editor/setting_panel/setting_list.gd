@tool
extends ggsTree


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	item_activated.connect(_on_item_activated)
	GGS.category_selected.connect(_on_Global_category_selected)


func add_item(setting: ggsSetting) -> void:
	var created_item: TreeItem = create_item(root)
	created_item.set_text(0, setting.name)
	created_item.set_icon(0, setting.icon)
	created_item.set_metadata(0, setting)


func remove_item(item: TreeItem) -> void:
	GGS.setting_selected.emit(null)
	item.free()
	_update_item_order()


func _load_list() -> void:
	clear()
	root = create_item()
	
	for item in GGS.active_category.item_order:
		add_item(item)
	
	GGS.setting_selected.emit(null)


func _on_item_selected() -> void:
	var selected_setting: ggsSetting = get_selected().get_metadata(0)
	ggsUtils.get_editor_interface().inspect_object(selected_setting)
	
	GGS.setting_selected.emit(selected_setting)


func _on_Global_category_selected(category: ggsCategory) -> void:
	if category == null:
		clear()
	else:
		_load_list()


### Drag and Drop

func _update_item_order() -> void:
	var new_order: Array[ggsSetting]
	for child in root.get_children():
		var setting_obj: ggsSetting = child.get_metadata(0)
		new_order.append(setting_obj)
	
	GGS.active_category.update_item_order(new_order)
