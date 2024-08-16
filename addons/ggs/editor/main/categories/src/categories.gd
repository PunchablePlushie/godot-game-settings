@tool
extends Control

@export_group("Nodes")
@export var AddField: LineEdit
@export var FilterField: LineEdit
@export var List: ItemList


func _ready() -> void:
	AddField.cat_creation_requested.connect(_on_cat_creation_requested)


func _create_category(cat_name: String) -> void:
	var settings_path: String = ggsPluginPref.new().get_config("PATH_settings")
	var dir: DirAccess = DirAccess.open(settings_path)
	dir.make_dir(cat_name)
	EditorInterface.get_resource_filesystem().scan()


func _on_cat_creation_requested(cat_name: String) -> void:
	_create_category(cat_name)
	List.load_list()
