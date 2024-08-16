@tool
extends ItemList

@export_group("Nodes")
@export var ContextMenu: PopupMenu


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	item_clicked.connect(_on_item_clicked)
	empty_clicked.connect(_on_empty_clicked)
	ContextMenu.id_pressed.connect(_on_ContextMenu_id_pressed)
	GGS.Event.PopupNotif.category_rename_resolved.connect(
			_on_rename_resolved)
	
	load_list()


# Load Categories #
func load_list() -> void:
	clear()
	
	var categories: PackedStringArray = _load_from_filesystem()
	for category in categories:
		var idx: int = add_item(category)
	
	GGS.State.selected_category = ""


func _load_from_filesystem() -> PackedStringArray:
	var settings_path: String = ggsPluginPref.new().get_config("PATH_settings")
	var dir: DirAccess = DirAccess.open(settings_path)
	
	# Temporarily converted to Array so we can use filter().
	var list: Array = Array(dir.get_directories()).filter(_remove_underscored)
	return PackedStringArray(list)


func _remove_underscored(element: String) -> bool:
	return not element.begins_with("_")


# Item Interaction #
func _on_item_selected(item_index: int) -> void:
	GGS.State.selected_category = get_item_text(item_index)


# Context Menu Visibility #
func _show_context_menu(at_position: Vector2, disable_category_actions: bool) -> void:
	# For some reason the menu won't popup at the exact cursor location
	# without this offset.
	var offset: Vector2 = Vector2(0, -22)
	
	ContextMenu.position = global_position + at_position - offset
	ContextMenu.set_category_actions_disabled(disable_category_actions)
	ContextMenu.popup()


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != MOUSE_BUTTON_RIGHT:
		return
	
	_show_context_menu(at_position, false)


func _on_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != MOUSE_BUTTON_RIGHT:
		return
	
	_show_context_menu(at_position, true)


# Context Menu Interaction #
func _on_ContextMenu_id_pressed(id: int) -> void:
	var selected_cat: String = GGS.State.selected_category
	match id:
		ContextMenu.ItemId.RENAME:
			GGS.Event.PopupNotif.category_rename_requested.emit(selected_cat)


# Rename #
func _on_rename_resolved(prev_name: String, new_name: String) -> void:
	var settings_path: String = ggsPluginPref.new().get_config("PATH_settings")
	var dir: DirAccess = DirAccess.open(settings_path)
	dir.rename(prev_name, new_name)
	load_list()
	EditorInterface.get_resource_filesystem().scan()
