@tool
extends ItemList

signal items_loaded

@export var _type: ggsCore.ItemType = ggsCore.ItemType.NIL

var _unfiltered_list: PackedStringArray

@onready var Menu: PopupMenu = $ContextMenu


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	item_clicked.connect(_on_item_clicked)
	empty_clicked.connect(_on_empty_clicked)
	Menu.id_pressed.connect(_on_Menu_id_pressed)
	GGS.Event.item_selected.connect(_on_Global_item_selected)
	GGS.Event.rename_confirmed.connect(_on_Global_rename_confirmed)
	GGS.Event.delete_confirmed.connect(_on_Global_delete_confirmed)
	
	if _type == ggsCore.ItemType.CATEGORY:
		load_item()


func filter_list(filter: String) -> void:
	_create_from_arr(_unfiltered_list)
	
	if filter.is_empty():
		return
	
	var filter_lowercase: String = filter.to_lower()
	var list: PackedStringArray
	for idx in item_count:
		var item_text: String = get_item_text(idx)
		if item_text.begins_with(filter_lowercase):
			list.append(item_text)
	
	_create_from_arr(list, true)


func _create_from_arr(list: PackedStringArray, is_filtered: bool = false) -> void:
	if not is_filtered:
		_unfiltered_list = list
	
	clear()
	for item in list:
		add_item(item)


func _on_item_selected(item_index: int) -> void:
	var item: String = get_item_text(item_index)
	GGS.Event.item_selected.emit(_type, item)


#region Loading
func load_item() -> void:
	var items: PackedStringArray = _load_from_disc()
	_create_from_arr(items)
	
	items_loaded.emit()
	GGS.Event.item_selected.emit(_type, "")


func _load_from_disc() -> PackedStringArray:
	var path: String = GGS.Pref.data.paths["settings"]
	match _type:
		ggsCore.ItemType.GROUP:
			path = path.path_join(GGS.State.selected_category)
		ggsCore.ItemType.SETTING:
			path = path.path_join(GGS.State.selected_category)
			path = path.path_join(GGS.State.selected_group)
	
	var dirs: PackedStringArray = DirAccess.get_directories_at(path)
	return GGS.Util.remove_underscored(dirs)


func _on_Global_item_selected(item_type: ggsCore.ItemType, item_name: String) -> void:
	match item_type:
		ggsCore.ItemType.CATEGORY:
			if _type == ggsCore.ItemType.SETTING:
				print("LOL!")

#endregion


#region Context Menu
func _show_menu(at_position: Vector2, disable_item_actions: bool) -> void:
	# For some reason the menu won't popup at the exact cursor location
	# without this offset.
	var offset: Vector2 = Vector2(0, -22)
	
	Menu.position = global_position + at_position - offset
	Menu.set_item_actions_disabled(disable_item_actions)
	Menu.popup()


func _on_item_clicked(_index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		_show_menu(at_position, false)


func _on_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		_show_menu(at_position, true)


func _on_Menu_id_pressed(id: int) -> void:
	var item: String
	
	match _type:
		ggsCore.ItemType.CATEGORY:
			item = GGS.State.selected_category
		ggsCore.ItemType.GROUP:
			item = GGS.State.selected_group
		ggsCore.ItemType.SETTING:
			item = GGS.State.selected_setting
		
	
	match id:
		Menu.ItemId.RENAME:
			GGS.Event.rename_requested.emit(_type, item)
		
		Menu.ItemId.DELETE:
			GGS.Event.delete_requested.emit(_type, item)
		
		Menu.ItemId.FILESYSTEM_GODOT:
			GGS.Util.show_item_in_filesystem_godot(_type, item)
		
		Menu.ItemId.FILESYSTEM_OS:
			GGS.Util.show_item_in_filesystem_os(_type, item)
		
		Menu.ItemId.RELOAD:
			load_item()
			print("GGS - Reload Categories: Successful.")


func _on_Global_rename_confirmed(_item_type: ggsCore.ItemType, _prev_name: String, _new_name: String) -> void:
	load_item()


func _on_Global_delete_confirmed(_item_type: ggsCore.ItemType, _item_name: String) -> void:
	load_item()

#endregion
