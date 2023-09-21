@tool
extends Control

@onready var AddBtn: Button = %AddBtn
@onready var NSF: LineEdit = %NewSettingField
@onready var NGF: LineEdit = %NewGroupField
@onready var CollapseAllBtn: Button = %CollapseAllBtn
@onready var ExpandAllBtn: Button = %ExpandAllBtn
@onready var ReloadBtn: Button = %ReloadBtn
@onready var List: Tree = %SettingList
@onready var CMenu: PopupMenu = %ContextMenu
@onready var ASW: ConfirmationDialog = $AddSettingWindow
@onready var InvalidName: AcceptDialog = $InvalidName
@onready var AlreadyExists: AcceptDialog = $AlreadyExists
@onready var DeleteConfirm: ConfirmationDialog = $DeleteConfirm

var item_prev_name: String


func _ready() -> void:
#	AddBtn.pressed.connect(_on_AddBtn_pressed)
#	ASW.setting_selected.connect(_on_ASW_setting_selected)
	
	List.item_edited.connect(_on_List_item_edited)
	List.item_activated.connect(_on_List_item_activated)
	
#	GGS.category_selected.connect(_on_Global_category_selected)
#	GGS.setting_selected.connect(_on_Global_setting_selected)
	CollapseAllBtn.pressed.connect(_on_CollapseAllBtn_pressed)
	ExpandAllBtn.pressed.connect(_on_ExpandAllBtn_pressed)
	ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)
	CMenu.id_pressed.connect(_on_CMenu_id_pressed)
	DeleteConfirm.confirmed.connect(_on_DeleteConfirm_confirmed)


func _on_CollapseAllBtn_pressed() -> void:
	pass


func _on_ExpandAllBtn_pressed() -> void:
	pass


func _on_ReloadBtn_pressed() -> void:
	pass


### Adding Settings
#
#func _add_setting(setting: ggsSetting) -> void:
#	var name_list: PackedStringArray = GGS.active_category.get_setting_name_list()
#	setting.name = ggsUtils.get_unique_string(name_list, setting.name)
#	setting.category = GGS.active_category.name
#	setting.current = setting.default
#
#	List.add_item(setting)
#	GGS.active_category.add_setting(setting)
#	ggsSaveFile.new().set_key(setting.category, setting.name, setting.default)
#
#
#func _on_AddBtn_pressed() -> void:
#	ASW.popup_centered()
#
#
#func _on_ASW_setting_selected(selected_setting: ggsSetting) -> void:
#	_add_setting(selected_setting)


### Renaming Settings
#
#func _rename_setting(tree_item: TreeItem) -> void:
#	var setting: ggsSetting = tree_item.get_metadata(0)
#	var prev_name: String = setting.name
#	var new_name: String = tree_item.get_text(0)
#
#	if prev_name == new_name:
#		return
#
#	var name_list: PackedStringArray = GGS.active_category.get_setting_name_list()
#	setting.name = ggsUtils.get_unique_string(name_list, new_name)
#
#	GGS.active_category.rename_setting(prev_name, setting)
#	ggsSaveFile.new().rename_key(setting.category, prev_name, setting.name)
#
#	tree_item.set_text(0, setting.name)
#	tree_item.set_editable(0, false)
#
#
#func _on_List_item_edited() -> void:
#	_rename_setting(List.get_edited())


### Deleting Settings
#
#func _delete_setting(setting: ggsSetting) -> void:
#	GGS.active_category.remove_setting(setting)
#	ggsSaveFile.new().delete_key(setting.category, setting.name)
#	List.remove_item(List.get_selected())
#	setting.delete()
#
#
#func _on_Global_category_selected(category: ggsCategory) -> void:
#	DeleteBtn.disabled = true
#	AssignBtn.disabled = true
#
#	AddBtn.disabled = (category == null)
#
#
#func _on_Global_setting_selected(setting: ggsSetting) -> void:
#	DeleteBtn.disabled = (setting == null)
#	AssignBtn.disabled = (setting == null)
#
#
#func _on_DeleteBtn_pressed() -> void:
#	DeleteConfirm.popup_centered()
#
#
#func _on_DeleteConfirm_confirmed() -> void:
#	_delete_setting(List.get_selected().get_metadata(0))



### Context Menu

func _on_CMenu_id_pressed(id: int) -> void:
	match id:
		List.ContextMenu.RENAME:
			item_prev_name = List.get_selected().get_text(0)
			List.edit_selected(true)
		
		List.ContextMenu.DELETE:
			DeleteConfirm.popup_centered()
		
		List.ContextMenu.SHOW_IN_FILE_SYSTEM:
			_show_in_file_system(List.get_selected())


# Rename
func _rename_item(item: TreeItem) -> void:
	var new_name: String = item.get_text(0)
	
	if new_name == item_prev_name:
		return
	
	if (
		not new_name.is_valid_filename() or
		new_name.begins_with("_") or
		new_name.begins_with(".") or
		new_name.begins_with("-")
	):
		InvalidName.popup_centered()
		List.get_selected().set_text(0, item_prev_name)
		return
	
	var item_is_group: bool = item.get_metadata(0)["is_group"]
	if item_is_group:
		_rename_group(item, new_name)
	else:
		_rename_setting(item, new_name)
	
	List.load_list()
	ggsUtils.get_resource_file_system().scan()
#	GGS.setting_selected.emit("")


func _rename_group(item: TreeItem, new_name: String) -> void:
	var dir: DirAccess = DirAccess.open(item.get_metadata(0)["path"].get_base_dir())
	if dir.dir_exists("-%s"%new_name):
		AlreadyExists.popup_centered()
		List.get_selected().set_text(0, item_prev_name)
		return
	
	dir.rename("-%s"%item_prev_name, "-%s"%new_name)


func _rename_setting(item: TreeItem, new_name: String) -> void:
	var dir: DirAccess = DirAccess.open(item.get_metadata(0)["path"].get_base_dir())
	if dir.dir_exists(new_name):
		AlreadyExists.popup_centered()
		List.get_selected().set_text(0, item_prev_name)
		return
	
	dir.open(item.get_metadata(0)["path"])
	prints(item.get_metadata(0)["path"], "%s.tres"%item_prev_name, "%s.tres"%new_name)
	var err = dir.rename("%s.tres"%item_prev_name, "%s.tres"%new_name)
	print(err)
	if dir.file_exists("%s.gd"%item_prev_name):
		dir.rename("%s.gd"%item_prev_name, "%s.gd"%new_name)
	
#	dir.open(item.get_metadata(0)["path"].get_base_dir())
#	dir.rename(item_prev_name, new_name)


func _on_List_item_activated() -> void:
	item_prev_name = List.get_selected().get_text(0)
	List.edit_selected(true)


func _on_List_item_edited() -> void:
	var edited_item: TreeItem = List.get_selected()
	_rename_item(edited_item)


# Delete
func _on_DeleteConfirm_confirmed() -> void:
#	ggsSaveFile.new().delete_section(category.get_text(0))
	List.remove_item(List.get_selected())


# Show In File System
func _show_in_file_system(item: TreeItem) -> void:
	var path: String = item.get_metadata(0)["path"]
	ggsUtils.get_editor_interface().select_file(path)
