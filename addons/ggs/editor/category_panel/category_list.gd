@tool
extends ggsTree

@onready var FSD: FileSystemDock = ggsUtils.get_file_system_dock()


func _ready() -> void:
	item_activated.connect(_on_item_activated)
	item_selected.connect(_on_item_selected)
	
	FSD.folder_moved.connect(_on_FSD_folder_moved)
	FSD.folder_removed.connect(_on_FSD_folder_removed)
	
	load_list()


func add_item(category: String) -> void:
	var created_item: TreeItem = create_item(root)
	created_item.set_text(0, category)


func load_list() -> void:
	clear()
	root = create_item()
	
	var category_list: Array = _get_category_list()
	for category in category_list:
		add_item(category)
	
	GGS.category_selected.emit("")


func _update_from_file_system(path: String) -> void:
	if not ggsUtils.is_dir_in_settings(path):
		return
	
	load_list()


func _on_item_selected() -> void:
	var item_name: String = get_selected().get_text(0)
	GGS.category_selected.emit(item_name)


func _on_item_activated() -> void:
	var item_name: String = get_selected().get_text(0)
	var path: String = ggsUtils.get_plugin_data().dir_settings.path_join(item_name)
	ggsUtils.get_editor_interface().select_file(path)


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
