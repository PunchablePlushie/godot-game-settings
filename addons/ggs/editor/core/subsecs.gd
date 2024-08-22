@tool
extends PanelContainer

@export_group("Nodes")
@export var _Core: MarginContainer
@export var _NewBtn: Button
@export var _ResetBtn: Button
@export var _SelectAllBtn: Button
@export var _DeselectAllBtn: Button
@export var _ReloadBtn: Button
@export var _NewField: LineEdit
@export var _List: ItemList
@export var _DisabledLabel: Label

var base_path: String
var _item_name_is_valid: bool


func _ready() -> void:
	_NewBtn.toggled.connect(_on_NewBtn_toggled)
	_NewField.text_changed.connect(_on_NewField_text_changed)
	_NewField.text_submitted.connect(_on_NewField_text_submitted)
	
	_ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)
	_SelectAllBtn.pressed.connect(_on_SelectAllBtn_pressed)
	_DeselectAllBtn.pressed.connect(_on_DeselectAllBtn_pressed)
	_List.item_activated.connect(_on_List_item_activated)
	_List.item_selected.connect(_on_List_item_selected)
	_List.gui_input.connect(_on_List_gui_input)
	
	_NewField.hide()


func set_panel_disabled(disabled: bool) -> void:
	_NewBtn.disabled = disabled
	_ResetBtn.disabled = disabled
	_SelectAllBtn.disabled = disabled
	_DeselectAllBtn.disabled = disabled
	_ReloadBtn.disabled = disabled
	_DisabledLabel.visible = disabled
	_List.clear()
	
	if disabled:
		_NewBtn.set_pressed_no_signal(false)
		_NewField.hide()
		_NewField.clear()


#region Adding Items
func _set_item_name_valid(valid: bool) -> void:
	_item_name_is_valid = valid
	_NewField.right_icon = _Core.icon_valid if valid else _Core.icon_invalid


func _item_name_exists(item_name: String) -> bool:
	var path: String = base_path.path_join(item_name)
	return DirAccess.dir_exists_absolute(path)


func _on_NewBtn_toggled(toggled_on: bool) -> void:
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
	load_list()


#endregion


#region List
func load_list() -> void:
	_List.clear()
	
	var items: PackedStringArray = DirAccess.get_directories_at(base_path)
	for item: String in items:
		var idx: int = _List.add_item(item)
		_List.set_item_metadata(idx, base_path.path_join(item))


func _on_ReloadBtn_pressed() -> void:
	load_list()
	print("GGS - Reload Subsections: Successful")


func _on_SelectAllBtn_pressed() -> void:
	for idx: int in _List.item_count:
		_List.select(idx, false)


func _on_DeselectAllBtn_pressed() -> void:
	_List.deselect_all()


func _on_List_item_activated(idx: int) -> void:
	var path: String = _List.get_item_metadata(idx)
	EditorInterface.get_file_system_dock().navigate_to_path(path)


func _on_List_item_selected(idx: int) -> void:
	pass


func _on_List_gui_input(event: InputEvent) -> void:
	if (
		event is not InputEventMouseButton
		or event.button_index != MOUSE_BUTTON_RIGHT
		or not event.is_pressed()
	):
		return
	
	_List.deselect_all()

#endregion
