@tool
extends LineEdit

@export_group("Nodes")
@export var List: ggsItemList


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	List.loaded.connect(_on_List_loaded)
	GGS.Event.category_selected.connect(_on_Global_category_selected)


func _create_group(grp_name: String) -> void:
	var settings_path: String = GGS.Pref.res.paths["settings"]
	var path: String = settings_path.path_join(GGS.State.selected_category)
	var dir: DirAccess = DirAccess.open(path)
	dir.make_dir(grp_name)
	EditorInterface.get_resource_filesystem().scan()


func _on_text_submitted(sub_text: String) -> void:
	var category: String = GGS.State.selected_category
	if not GGS.Util.item_name_validate(sub_text, category):
		return
	
	_create_group(sub_text)
	List.load_list()
	clear()


func _on_List_loaded() -> void:
	clear()


func _on_Global_category_selected(category: String) -> void:
	if category.is_empty():
		clear()
		release_focus()
