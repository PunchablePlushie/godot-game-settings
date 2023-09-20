@tool
extends ggsTree

enum ContextMenu {RENAME, DELETE, SHOW_IN_FILE_SYSTEM}

var parent: TreeItem = root

@onready var CMenu: PopupMenu = $ContextMenu


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	item_mouse_selected.connect(_on_item_mouse_selected)
	
	GGS.active_category_updated.connect(_on_Global_active_category_updated)


func add_item(setting: String, path: String) -> void:
	var created_item: TreeItem = create_item(parent)
	created_item.set_text(0, setting)
	created_item.set_metadata(0, path)


func add_group_item(setting: String) -> TreeItem:
	var created_item: TreeItem = create_item(parent)
	created_item.set_text(0, setting.trim_prefix("-"))
	created_item.set_metadata(0, "")
	return created_item


func remove_item(item: TreeItem) -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var item_name: String = item.get_text(0)
	var path: String = ProjectSettings.globalize_path(data.dir_settings.path_join(item_name))
	OS.move_to_trash(path)
	
	item.free()
	GGS.setting_selected.emit("")
	ggsUtils.get_resource_file_system().scan()


func load_list() -> void:
	clear()
	root = create_item()
	
	var item_list: Array = _get_item_list()
	for item in item_list:
		parent = root
		
		if item.begins_with("-"):
			parent = add_group_item(item)
			_load_group(item)
		else:
			var path: String = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category).path_join(item)
			add_item(item, path)
	
	GGS.setting_selected.emit(null)


func _on_item_selected() -> void:
	var item_meta: String = get_selected().get_metadata(0)
	if item_meta.is_empty():
		return
	
	var item_name: String = get_selected().get_text(0)
	var setting_res: ggsSetting = load("%s/%s.tres"%[item_meta, item_name])
	ggsUtils.get_editor_interface().inspect_object(setting_res)
#	GGS.setting_selected.emit("%s/%s.tres"%[item_meta, item_name])


func _on_Global_active_category_updated() -> void:
	if GGS.active_category.is_empty():
		clear()
	else:
		load_list()


### Get Item List

func _get_item_list() -> Array:
	var path: String = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
	var dir: DirAccess = DirAccess.open(path)
	var list: Array = Array(dir.get_directories()).filter(_remove_underscored)
	return list


func _load_group(group: String) -> void:
	var base_path: String = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
	var group_path: String = base_path.path_join(group)
	var dir: DirAccess = DirAccess.open(base_path.path_join(group))
	var list: Array = Array(dir.get_directories()).filter(_remove_underscored)
	for item in list:
		var path: String = group_path.path_join(item)
		add_item(item, path)


func _remove_underscored(element: String) -> bool:
	return not element.begins_with("_")


### Show Context Menu

func _on_item_mouse_selected(pos: Vector2, mouse_btn: int) -> void:
	if not mouse_btn == MOUSE_BUTTON_RIGHT:
		return
	
	CMenu.position = DisplayServer.mouse_get_position()
	CMenu.popup()
