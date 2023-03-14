@tool
extends Control

@onready var AddBtn: Button = %AddBtn
@onready var DeleteBtn: Button = %DeleteBtn
@onready var AssignBtn: Button = %AssignBtn
@onready var List: Tree = %SettingList
@onready var ASW: ConfirmationDialog = $AddSettingWindow
@onready var DeleteConfirm: ConfirmationDialog = $DeleteConfirm


func _ready() -> void:
	AddBtn.pressed.connect(_on_AddBtn_pressed)
	ASW.setting_selected.connect(_on_ASW_setting_selected)
	
	List.item_edited.connect(_on_List_item_edited)
	
	GGS.category_selected.connect(_on_Global_category_selected)
	GGS.setting_selected.connect(_on_Global_setting_selected)
	DeleteBtn.pressed.connect(_on_DeleteBtn_pressed)
	DeleteConfirm.confirmed.connect(_on_DeleteConfirm_confirmed)
	
	AssignBtn.pressed.connect(_on_AssignBtn_pressed)



### Adding Settings

func _add_setting(setting: ggsSetting) -> void:
	var name_list: PackedStringArray = GGS.active_category.get_setting_name_list()
	setting.name = ggsUtils.get_unique_string(name_list, setting.name)
	setting.category = GGS.active_category.name
	setting.current = setting.default
	
	List.add_item(setting)
	GGS.active_category.add_setting(setting)
	ggsSaveFile.new().set_key(setting.category, setting.name, setting.default)


func _on_AddBtn_pressed() -> void:
	ASW.popup_centered()


func _on_ASW_setting_selected(selected_setting: ggsSetting) -> void:
	_add_setting(selected_setting)


### Renaming Settings

func _rename_setting(tree_item: TreeItem) -> void:
	var setting: ggsSetting = tree_item.get_metadata(0)
	var prev_name: String = setting.name
	var new_name: String = tree_item.get_text(0)
	
	if prev_name == new_name:
		return
	
	var name_list: PackedStringArray = GGS.active_category.get_setting_name_list()
	setting.name = ggsUtils.get_unique_string(name_list, new_name)
	
	GGS.active_category.rename_setting(prev_name, setting)
	ggsSaveFile.new().rename_key(setting.category, prev_name, setting.name)
	
	tree_item.set_text(0, setting.name)
	tree_item.set_editable(0, false)


func _on_List_item_edited() -> void:
	_rename_setting(List.get_edited())


### Deleting Settings

func _delete_setting(setting: ggsSetting) -> void:
	GGS.active_category.remove_setting(setting)
	ggsSaveFile.new().delete_key(setting.category, setting.name)
	List.remove_item(List.get_selected())
	setting.delete()


func _on_Global_category_selected(category: ggsCategory) -> void:
	DeleteBtn.disabled = true
	AssignBtn.disabled = true
	
	AddBtn.disabled = (category == null)


func _on_Global_setting_selected(setting: ggsSetting) -> void:
	DeleteBtn.disabled = (setting == null)
	AssignBtn.disabled = (setting == null)


func _on_DeleteBtn_pressed() -> void:
	DeleteConfirm.popup_centered()


func _on_DeleteConfirm_confirmed() -> void:
	_delete_setting(List.get_selected().get_metadata(0))


### Assigning Settings

func _on_AssignBtn_pressed() -> void:
	var EI: EditorInterface = ggsUtils.get_editor_interface()
	var ES: EditorSelection = EI.get_selection()
	var selected_nodes: Array[Node] = ES.get_selected_nodes()
	
	if selected_nodes.size() != 1:
		printerr("GGS - Assign to Component: Exactly 1 item in the scene tree must be selected.")
		return
	
	var SelectedNode: Node = selected_nodes[0]
	if not SelectedNode is ggsUIComponent:
		printerr("GGS - Assign to Component: The selected node is not a GGS UI Component.")
		return
	
	SelectedNode.setting = GGS.active_setting
	EI.save_scene()
