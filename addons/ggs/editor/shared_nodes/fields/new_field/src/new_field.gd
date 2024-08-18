@tool
extends ggsBasePanelField

var _selected_category: String
var _selected_group: String


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)


func _create_item(item_name: String) -> void:
	var settings_path: String = GGS.Pref.data.paths["settings"]
	var parent_path: String = settings_path.path_join(_selected_category)
	var item_path: String = parent_path.path_join(item_name)
	DirAccess.make_dir_absolute(item_path)
	EditorInterface.get_resource_filesystem().scan()


func _on_text_submitted(sub_text: String) -> void:
	if not GGS.Util.item_name_validate(sub_text):
		return
	
	_create_item(sub_text)
	List.load_list()
	clear()


func _on_category_selected(category: String) -> void:
	super(category)
	_selected_category = category


func _on_group_selected(group: String) -> void:
	super(group)
	_selected_group = group
