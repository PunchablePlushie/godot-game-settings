@tool
extends ggsTree

enum ContextMenu {RENAME, DELETE, SHOW_IN_FILE_SYSTEM}

@onready var CMenu: PopupMenu = $ContextMenu
@onready var FSD: FileSystemDock = ggsUtils.get_file_system_dock()


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	item_mouse_selected.connect(_on_item_mouse_selected)
	
	FSD.folder_moved.connect(_on_FSD_folder_moved)
	FSD.folder_removed.connect(_on_FSD_folder_removed)
	
	load_list()


func add_item(category: String) -> void:
	var created_item: TreeItem = create_item(root)
	created_item.set_text(0, category)


func remove_item(item: TreeItem) -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var item_name: String = item.get_text(0)
	var path: String = ProjectSettings.globalize_path(data.dir_settings.path_join(item_name))
	OS.move_to_trash(path)
	
	item.free()
	GGS.category_selected.emit("")
	ggsUtils.get_resource_file_system().scan()


func load_list() -> void:
	clear()
	root = create_item()
	
#	var start_time: int = Time.get_ticks_msec()
	var category_list: Array = _get_category_list()
	for category in category_list:
		add_item(category)
#	var end_time: int = Time.get_ticks_msec()
#	print("GGS - Load Categories: Successfull (%dms)"%[end_time - start_time])


func _update_from_file_system(path: String) -> void:
	if not ggsUtils.is_dir_in_settings(path):
		return
	
	load_list()
	GGS.category_selected.emit("")


func _on_item_selected() -> void:
	GGS.category_selected.emit(get_selected().get_text(0))


func _on_FSD_folder_moved(old_folder: String, _new_folder: String) -> void:
	_update_from_file_system(old_folder)


func _on_FSD_folder_removed(folder: String) -> void:
	_update_from_file_system(folder)


### Get Category List

func _get_category_list() -> Array:
	var dir: DirAccess = DirAccess.open(ggsUtils.get_plugin_data().dir_settings)
	var list: Array = Array(dir.get_directories()).filter(_remove_underscored)
	return list


func _remove_underscored(element: String) -> bool:
	return not element.begins_with("_")


### Show Context Menu

func _on_item_mouse_selected(pos: Vector2, mouse_btn: int) -> void:
	if not mouse_btn == MOUSE_BUTTON_RIGHT:
		return
	
	CMenu.position = DisplayServer.mouse_get_position()
	CMenu.popup()
