@tool
extends Control

@export_group("Nodes")
@export var Field: LineEdit
@export var List: ItemList
@export var ReloadBtn: Button


func _ready() -> void:
	Field.text_submitted.connect(_on_Field_text_submitted)
	ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)


# Category Creation #
func _create_category(cat_name: String) -> void:
	var dir_settings: String = ggsPluginPref.new().get_config("dir_settings")
	var dir: DirAccess = DirAccess.open(dir_settings)
	dir.make_dir(cat_name)
	Field.clear()


func _name_is_valid(cat_name: String) -> bool:
	return (
		cat_name.is_valid_filename() 
		and not cat_name.begins_with("_") 
		and not cat_name.begins_with(".")
	)


func _on_Field_text_submitted(submitted_text: String) -> void:
	if not _name_is_valid(submitted_text):
		GGS.Event.PopupNotif.name_invalid.emit()
		return
	
	var dir_settings: String = ggsPluginPref.new().get_config("dir_settings")
	var dir: DirAccess = DirAccess.open(dir_settings)
	if dir.dir_exists(submitted_text):
		GGS.Event.PopupNotif.name_exists.emit()
		return
	
	_create_category(submitted_text)
	EditorInterface.get_resource_filesystem().scan()
	List.load_list()


func _on_ReloadBtn_pressed() -> void:
	List.load_list()
