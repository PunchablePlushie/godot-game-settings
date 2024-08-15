@tool
extends Control

@export var Notification: AcceptDialog

@onready var NCF: LineEdit = %NewCatField
@onready var ReloadBtn: Button = %ReloadBtn
@onready var List: ItemList = %CategoryList


func _ready() -> void:
	NCF.text_submitted.connect(_on_NCF_text_submitted)
	ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)


### Category Creation

func _create_category(cat_name: String) -> void:
	var dir: DirAccess = DirAccess.open(ggsUtils.get_plugin_data().dir_settings)
	dir.make_dir(cat_name)
	
	NCF.clear()


func _on_NCF_text_submitted(submitted_text: String) -> void:
	if (
		not submitted_text.is_valid_filename() or
		submitted_text.begins_with("_") or
		submitted_text.begins_with(".")
	):
		Notification.purpose = Notification.Purpose.INVALID
		Notification.popup_centered()
		return
	
	var dir: DirAccess = DirAccess.open(ggsUtils.get_plugin_data().dir_settings)
	if dir.dir_exists(submitted_text):
		Notification.purpose = Notification.Purpose.ALREADY_EXISTS
		Notification.popup_centered()
		return
	
	_create_category(submitted_text)
	ggsUtils.get_resource_file_system().scan()
	List.load_list()


### Reload Btn

func _on_ReloadBtn_pressed() -> void:
	List.load_list()
