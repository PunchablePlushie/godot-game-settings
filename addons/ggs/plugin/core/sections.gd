@tool
extends PanelContainer

@export_group("Nodes")
@export var _Core: MarginContainer
@export var _NewBtn: Button
@export var _ReloadBtn: Button
@export var _NewField: LineEdit
@export var List: ItemList
@export var _Subsecs: PanelContainer
@export var _Settings: PanelContainer

var base_path: String
var _item_name_is_valid: bool


func _ready() -> void:
	_NewBtn.toggled.connect(_on_NewBtn_togged)
	_NewField.text_changed.connect(_on_NewField_text_changed)
	_NewField.text_submitted.connect(_on_NewField_text_submitted)
	
	_ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)
	List.item_activated.connect(_on_List_item_activated)
	List.item_selected.connect(_on_List_item_selected)
	
	base_path = GGS.Pref.path_settings
	_NewField.hide()
	_load_list()


#region Adding Items
func _set_item_name_valid(valid: bool) -> void:
	_item_name_is_valid = valid
	_NewField.right_icon = _Core.icon_valid if valid else _Core.icon_invalid


func _item_name_exists(item_name: String) -> bool:
	var path: String = base_path.path_join(item_name)
	return DirAccess.dir_exists_absolute(path)


func _on_NewBtn_togged(toggled_on: bool) -> void:
	_set_item_name_valid(false)
	_NewField.visible = toggled_on
	if toggled_on:
		_NewField.clear()
		_NewField.grab_focus()


func _on_NewField_text_changed(new_text: String) -> void:
	if not ggsUtils.item_name_is_valid(new_text):
		_set_item_name_valid(false)
		return
	
	if _item_name_exists(new_text):
		_set_item_name_valid(false)
		return
	
	_set_item_name_valid(true)


func _on_NewField_text_submitted(new_text: String) -> void:
	if not _item_name_is_valid:
		return
	
	_NewField.clear()
	
	var path: String = base_path.path_join(new_text)
	DirAccess.make_dir_absolute(path)
	EditorInterface.get_resource_filesystem().scan()
	_load_list()

#endregion


#region List
func _load_list() -> void:
	List.clear()
	_Subsecs.set_panel_disabled(true)
	_Settings.set_panel_disabled(true)
	
	var items: PackedStringArray = DirAccess.get_directories_at(base_path)
	for item: String in items:
		var idx: int = List.add_item(item.capitalize())
		List.set_item_metadata(idx, base_path.path_join(item))


func _on_ReloadBtn_pressed() -> void:
	_load_list()
	print("GGS - Reload Sections: Successful")


func _on_List_item_activated(idx: int) -> void:
	var path: String = List.get_item_metadata(idx)
	EditorInterface.get_file_system_dock().navigate_to_path(path)


func _on_List_item_selected(idx: int) -> void:
	_Subsecs.base_path = List.get_item_metadata(idx)
	_Subsecs.set_panel_disabled(false)
	_Subsecs.load_list()
	
	_Settings.base_path = List.get_item_metadata(idx)
	_Settings.set_panel_disabled(false)
	_Settings.load_list()

#endregion
