@tool
extends LineEdit

@export_group("Nodes")
@export var List: ggsItemList


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	List.loaded.connect(_on_List_loaded)


func _create_category(cat_name: String) -> void:
	var settings_path: String = ggsPluginPref.new().get_config("PATH_settings")
	var dir: DirAccess = DirAccess.open(settings_path)
	dir.make_dir(cat_name)
	EditorInterface.get_resource_filesystem().scan()


func _on_text_submitted(sub_text: String) -> void:
	if not GGS.Util.item_name_validate(sub_text):
		return
	
	_create_category(sub_text)
	List.load_list()
	clear()


func _on_List_loaded() -> void:
	clear()
