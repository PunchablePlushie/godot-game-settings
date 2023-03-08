@tool
extends Control

@onready var NCF: LineEdit = %NewCatField
@onready var AddBtn: Button = %AddBtn
@onready var List: Tree = %CategoryList
@onready var CMenu: PopupMenu = %ContextMenu
@onready var DeleteConfirm: ConfirmationDialog = $DeleteConfirm


func _ready() -> void:
	NCF.text_changed.connect(_on_NCF_text_changed)
	NCF.text_submitted.connect(_on_NCF_text_submitted)
	AddBtn.pressed.connect(_on_AddBtn_pressed)
	
	List.item_edited.connect(_on_List_item_edited)
	
	CMenu.index_pressed.connect(_on_CMenu_index_pressed)
	DeleteConfirm.confirmed.connect(_on_DeleteConfirm_confirmed)


### Category Creation

func _create_category_object(cat_name: String) -> ggsCategory:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var name_list: PackedStringArray = data.get_category_name_list()
	cat_name = ggsUtils.get_unique_string(name_list, cat_name)
	
	var new_cat: ggsCategory = ggsCategory.new()
	new_cat.name = cat_name
	return new_cat


func _create_category(cat_name: String) -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var category_obj: ggsCategory = _create_category_object(cat_name)
	data.add_category(category_obj)
	List.add_item(category_obj)
	
	AddBtn.disabled = true
	NCF.clear()


func _is_name_valid(cat_name: String) -> bool:
	return not cat_name.strip_edges().is_empty()


func _on_NCF_text_changed(new_text: String) -> void:
	AddBtn.disabled = not _is_name_valid(new_text)


func _on_NCF_text_submitted(submitted_text: String) -> void:
	if _is_name_valid(submitted_text):
		_create_category(submitted_text)


func _on_AddBtn_pressed() -> void:
	_create_category(NCF.text)


### Category Renaming

func _rename_category(tree_item: TreeItem) -> void:
	var category: ggsCategory = tree_item.get_metadata(0)
	var prev_name: String = category.name
	var new_name: String = tree_item.get_text(0)
	
	if prev_name == new_name:
		return
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var name_list: PackedStringArray = data.get_category_name_list()
	category.name = ggsUtils.get_unique_string(name_list, new_name)
	
	data.rename_category(prev_name, category)
	ggsSaveFile.new().rename_section(prev_name, category.name)
	
	tree_item.set_text(0, category.name)
	tree_item.set_editable(0, false)


func _on_List_item_edited() -> void:
	_rename_category(List.get_edited())


### Context Menu

func _on_CMenu_index_pressed(index: int) -> void:
	var category: ggsCategory = List.get_selected().get_metadata(0)
	match index:
		0:
			DeleteConfirm.popup_centered()
		1:
			_inspect_category(category)


# Category Deletion
func _delete_category(category: ggsCategory) -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	data.remove_category(category)
	ggsSaveFile.new().delete_section(category.name)
	List.remove_item(List.get_selected())


func _on_DeleteConfirm_confirmed() -> void:
	_delete_category(List.get_selected().get_metadata(0))


# Category Inspection
func _inspect_category(category: ggsCategory) -> void:
	ggsUtils.get_editor_interface().inspect_object(category)
