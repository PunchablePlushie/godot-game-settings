@tool
extends ggsTree

var parent: TreeItem = root
var cur_path: String


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	item_activated.connect(_on_item_activated)
	
	GGS.active_category_updated.connect(_on_Global_active_category_updated)


func add_item(setting: String, path: String) -> void:
	var created_item: TreeItem = create_item(parent)
	created_item.set_text(0, setting)
	created_item.set_metadata(0, {"is_group": false, "path": path})


func add_group_item(setting: String, path: String) -> TreeItem:
	var created_item: TreeItem = create_item(parent)
	created_item.set_text(0, setting.trim_prefix("-"))
	created_item.set_metadata(0, {"is_group": true, "path": path})
	return created_item


func load_list() -> void:
	clear()
	root = create_item()
	
	var item_list: Array = _get_item_list()
	for item in item_list:
		parent = root
		cur_path = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category).path_join(item)
		
		if item.begins_with("-"):
			parent = add_group_item(item, cur_path)
			_load_group(item, parent)
		else:
			add_item(item, cur_path)
	
	GGS.setting_selected.emit(null)


func _on_item_activated() -> void:
	var path: String = get_selected().get_metadata(0)["path"]
	ggsUtils.get_editor_interface().select_file(path)


func _on_item_selected() -> void:
	return
	var item_meta: Dictionary = get_selected().get_metadata(0)
	if item_meta["is_group"]:
		return
	
	var item_name: String = get_selected().get_text(0)
	var setting_res: ggsSetting = load("%s/%s.tres"%[item_meta["path"], item_name])
	ggsUtils.get_editor_interface().inspect_object(setting_res)
#	GGS.setting_selected.emit("%s/%s.tres"%[item_meta, item_name])


func _on_Global_active_category_updated() -> void:
	if GGS.active_category.is_empty():
		clear()
	else:
		load_list()


### Get Item List

func _get_item_list() -> Array:
#	var path: String = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
	cur_path = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
	var dir: DirAccess = DirAccess.open(cur_path)
	var list: Array = Array(dir.get_directories()).filter(_remove_underscored)
	return list


func _load_group(group: String, group_item: TreeItem) -> void:
	var group_path: String = cur_path
	var dir: DirAccess = DirAccess.open(cur_path)
	var item_list: Array = Array(dir.get_directories()).filter(_remove_underscored)
	
	for item in item_list:
		parent = group_item
		cur_path = group_path.path_join(item)
		
		if item.begins_with("-"):
			parent = add_group_item(item, cur_path)
			_load_group(item, parent)
		else:
			add_item(item, cur_path)


func _remove_underscored(element: String) -> bool:
	return not element.begins_with("_")
