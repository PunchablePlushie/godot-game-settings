@tool
extends ItemList

@onready var FSD: FileSystemDock = ggsUtils.get_file_system_dock()


func _ready() -> void:
	item_activated.connect(_on_item_activated)
	item_selected.connect(_on_item_selected)
	
	FSD.folder_moved.connect(_on_FSD_folder_moved)
	FSD.folder_removed.connect(_on_FSD_folder_removed)
	FSD.files_moved.connect(_on_FSD_files_moved)
	FSD.file_removed.connect(_on_FSD_file_removed)
	
	load_list()


func load_list() -> void:
	clear()
	
	var categories: PackedStringArray = _load_categories_from_filesystem()
	for category in categories:
		add_item(category)
	
	GGS.active_category = ""


func _update_from_file_system(path: String) -> void:
	if not ggsUtils.path_is_in_dir_settings(path):
		return
	
	load_list()


func _on_item_selected(item_index: int) -> void:
	var item_text: String = get_item_text(item_index)
	GGS.active_category = item_text


func _on_item_activated(item_index: int) -> void:
	var item_text: String = get_item_text(item_index)
	var path: String = ggsUtils.get_plugin_data().dir_settings.path_join(item_text)
	ggsUtils.get_editor_interface().select_file(path)


func _on_FSD_folder_moved(old_folder: String, _new_folder: String) -> void:
	_update_from_file_system(old_folder)


func _on_FSD_folder_removed(folder: String) -> void:
	_update_from_file_system(folder)


func _on_FSD_files_moved(old_file: String, _new_file: String) -> void:
	_update_from_file_system(old_file)


func _on_FSD_file_removed(file: String) -> void:
	_update_from_file_system(file)


### Load Categories

func _load_categories_from_filesystem() -> PackedStringArray:
	var dir: DirAccess = DirAccess.open(ggsUtils.get_plugin_data().dir_settings)
	var list: Array = Array(dir.get_directories()).filter(_remove_underscored)
	return PackedStringArray(list)


func _remove_underscored(element: String) -> bool:
	return not element.begins_with("_")
