@tool
extends Control

@export var Notification: AcceptDialog

@onready var NCF: LineEdit = %NewCatField
@onready var ReloadBtn: Button = %ReloadBtn
@onready var List: Tree = %CategoryList

var item_prev_name: String


func _ready() -> void:
	NCF.text_submitted.connect(_on_NCF_text_submitted)
	ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)
	List.item_activated.connect(_on_List_item_activated)
	List.item_selected.connect(_on_List_item_selected)


### Category Creation

func _create_category(cat_name: String) -> void:
	var created_item: TreeItem = List.add_item(cat_name)
	NCF.clear()
	
	var dir: DirAccess = DirAccess.open(ggsUtils.get_plugin_data().dir_settings)
	dir.make_dir(cat_name)


func _on_NCF_text_submitted(submitted_text: String) -> void:
	if (
		not submitted_text.is_valid_filename() or
		submitted_text.begins_with("_") or
		submitted_text.begins_with(".") or
		submitted_text.begins_with("-")
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


### List

func _on_List_item_selected() -> void:
	var item_name: String = List.get_selected().get_text(0)
	GGS.category_selected.emit(item_name)


func _on_List_item_activated() -> void:
	var item_name: String = List.get_selected().get_text(0)
	var path: String = ggsUtils.get_plugin_data().dir_settings.path_join(item_name)
	ggsUtils.get_editor_interface().select_file(path)
