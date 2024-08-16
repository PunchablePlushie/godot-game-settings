@tool
extends Control

@export_group("Nodes")
@export var AddField: LineEdit
@export var FilterField: LineEdit
@export var List: ItemList


func _ready() -> void:
	AddField.text_submitted.connect(_on_AddField_text_submitted)


# Category Creation #
func _create_category(cat_name: String) -> void:
	var settings_path: String = ggsPluginPref.new().get_config("PATH_settings")
	var dir: DirAccess = DirAccess.open(settings_path)
	dir.make_dir(cat_name)
	AddField.clear()


func _on_AddField_text_submitted(submitted_text: String) -> void:
	if not ggsUtils.item_name_validate(submitted_text):
		return
	
	_create_category(submitted_text)
	EditorInterface.get_resource_filesystem().scan()
	List.load_list()
