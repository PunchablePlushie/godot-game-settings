@tool
extends Control

@onready var NCF: LineEdit = %NewCatField
@onready var ReloadBtn: Button = %ReloadBtn
@onready var List: Tree = %CategoryList
@onready var CMenu: PopupMenu = %ContextMenu
@onready var InvalidName: AcceptDialog = $InvalidName
@onready var AlreadyExists: AcceptDialog = $AlreadyExists
@onready var DeleteConfirm: ConfirmationDialog = $DeleteConfirm

var item_prev_name: String


func _ready() -> void:
	NCF.text_submitted.connect(_on_NCF_text_submitted)
	ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)

	CMenu.id_pressed.connect(_on_CMenu_id_pressed)
	List.item_edited.connect(_on_List_item_edited)
	List.item_activated.connect(_on_List_item_activated)
	DeleteConfirm.confirmed.connect(_on_DeleteConfirm_confirmed)


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
		submitted_text.begins_with(".")
	):
		InvalidName.popup_centered()
		return
	
	var dir: DirAccess = DirAccess.open(ggsUtils.get_plugin_data().dir_settings)
	if dir.dir_exists(submitted_text):
		AlreadyExists.popup_centered()
		return
	
	_create_category(submitted_text)
	ggsUtils.get_resource_file_system().scan()
	List.load_list()


func _on_ReloadBtn_pressed() -> void:
	List.load_list()


### Context Menu

func _on_CMenu_id_pressed(id: int) -> void:
	match id:
		List.ContextMenu.RENAME:
			item_prev_name = List.get_selected().get_text(0)
			List.edit_selected(true)
		
		List.ContextMenu.DELETE:
			DeleteConfirm.popup_centered()
		
		List.ContextMenu.SHOW_IN_FILE_SYSTEM:
			_show_in_file_system(List.get_selected().get_text(0))


# Rename
func _rename_category(new_name: String) -> void:
	if new_name == item_prev_name:
		return
	
	if (
		not new_name.is_valid_filename() or
		new_name.begins_with("_") or
		new_name.begins_with(".")
	):
		InvalidName.popup_centered()
		List.get_selected().set_text(0, item_prev_name)
		return
	
	var dir: DirAccess = DirAccess.open(ggsUtils.get_plugin_data().dir_settings)
	if dir.dir_exists(new_name):
		AlreadyExists.popup_centered()
		List.get_selected().set_text(0, item_prev_name)
		return
	
	dir.rename(item_prev_name, new_name)
	List.load_list()
	ggsUtils.get_resource_file_system().scan()
	GGS.category_selected.emit("")


func _on_List_item_activated() -> void:
	item_prev_name = List.get_selected().get_text(0)
	List.edit_selected(true)


func _on_List_item_edited() -> void:
	var edited_item: TreeItem = List.get_selected()
	_rename_category(edited_item.get_text(0))


# Delete
func _on_DeleteConfirm_confirmed() -> void:
#	ggsSaveFile.new().delete_section(category.get_text(0))
	List.remove_item(List.get_selected())


# Show In File System
func _show_in_file_system(cat_name: String) -> void:
	var path: String = ggsUtils.get_plugin_data().dir_settings.path_join(cat_name)
	ggsUtils.get_editor_interface().select_file(path)
