@tool
extends ggsBasePanelField

var _selected_category: String


func _ready() -> void:
	super()
	text_submitted.connect(_on_text_submitted)
	GGS.Event.category_selected.connect(_on_Global_category_selected)


func _create_group(item_name: String) -> void:
	var settings_path: String = GGS.Pref.data.paths["settings"]
	var parent_path: String = settings_path.path_join(_selected_category)
	var item_path: String = parent_path.path_join(item_name)
	DirAccess.make_dir_absolute(item_path)
	EditorInterface.get_resource_filesystem().scan()


func _on_text_submitted(submitted_text: String) -> void:
	if not GGS.Util.item_name_validate(submitted_text):
		return
	
	_create_group(submitted_text)
	List.load_list()
	clear()


func _on_Global_category_selected(category: String) -> void:
	set_disabled(category.is_empty())
	_selected_category = category
