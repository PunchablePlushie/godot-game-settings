@tool
extends ItemList

const _TYPE: ggsCore.ItemType = ggsCore.ItemType.CATEGORY

@export_group("Nodes")
@export var Menu: PopupMenu
@export var RenameWin: ConfirmationDialog
@export var DeleteWin: ConfirmationDialog


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	item_clicked.connect(_on_item_clicked)
	empty_clicked.connect(_on_empty_clicked)
	Menu.id_pressed.connect(_on_Menu_id_pressed)
	RenameWin.rename_confirmed.connect(_on_RenameWin_rename_confirmed)
	DeleteWin.delete_confirmed.connect(_on_DeleteWin_delete_confirmed)
	
	load_items()


func _on_item_selected(item_index: int) -> void:
	var item: String = get_item_text(item_index)
	GGS.Event.item_selected.emit(_TYPE, item)


#region Loading
func load_items() -> void:
	clear()
	
	var items: PackedStringArray = _load_from_disc()
	for item in items:
		add_item(item)
	
	GGS.Event.item_selected.emit(_TYPE, "")


func _load_from_disc() -> PackedStringArray:
	var path: String = GGS.Pref.data.paths["settings"]
	var dirs: PackedStringArray = DirAccess.get_directories_at(path)
	return GGS.Util.remove_underscored(dirs)

#endregion

#region Context Menu Visibility
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

#endregion

#region Context Menu Items
func _on_Menu_id_pressed(id: int) -> void:
	var selected_items: PackedInt32Array = get_selected_items()
	var selected_idx: int
	var item: String
	
	if selected_items.is_empty():
		selected_idx = -1
		item = ""
	else:
		selected_idx = selected_items[0]
		item = get_item_text(selected_items[0])
	
	match id:
		Menu.ItemId.RENAME:
			RenameWin.item_name = item
			RenameWin.popup_centered(RenameWin.min_size)
		
		Menu.ItemId.DELETE:
			DeleteWin.item_name = item
			DeleteWin.popup_centered(DeleteWin.min_size)
		
		Menu.ItemId.FILESYSTEM_GODOT:
			GGS.Util.show_item_in_filesystem_godot(_TYPE, item)
		
		Menu.ItemId.FILESYSTEM_OS:
			GGS.Util.show_item_in_filesystem_os(_TYPE, item)
		
		Menu.ItemId.RELOAD:
			load_items()
			print("GGS - Reload Categories: Successful.")


func _on_RenameWin_rename_confirmed(prev_name: String, new_name: String) -> void:
	var path: String = GGS.Pref.data.paths["settings"]
	var from: String = path.path_join(prev_name)
	var to: String = path.path_join(new_name)
	DirAccess.rename_absolute(from, to)
	
	EditorInterface.get_resource_filesystem().scan()
	load_items()


func _on_DeleteWin_delete_confirmed(item_name: String, is_permanent: bool) -> void:
	var path: String = GGS.Pref.data.paths["settings"]
	path = path.path_join(item_name)
	
	if is_permanent:
		DirAccess.remove_absolute(path)
	else:
		path = ProjectSettings.globalize_path(path)
		OS.move_to_trash(path)
	
	EditorInterface.get_resource_filesystem().scan()
	load_items()

#endregion
