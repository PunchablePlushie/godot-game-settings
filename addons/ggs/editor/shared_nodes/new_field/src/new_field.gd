@tool
extends LineEdit

enum Mode {NONE, CATEGORY, GROUP, SETTING}

@export var _mode: Mode = Mode.NONE
@export_group("Nodes")
@export var _List: ggsItemList

var _selected_category: String
var _selected_group: String


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	
	if _List:
		_List.loaded.connect(_on_List_loaded)
	
	match _mode:
		Mode.GROUP:
			GGS.Event.category_selected.connect(_on_category_selected)
		Mode.SETTING:
			GGS.Event.group_selected.connect(_on_group_selected)


#region Item Creation
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
	_List.load_list()
	clear()

#endregion


func _set_disabled(disabled: bool) -> void:
	editable = !disabled
	if disabled:
		clear()
		release_focus()



func _on_List_loaded() -> void:
	clear()


func _on_category_selected(category: String) -> void:
	_set_disabled(category.is_empty())
	_selected_category = category


func _on_group_selected(group: String) -> void:
	_set_disabled(group.is_empty())
	_selected_group = group
