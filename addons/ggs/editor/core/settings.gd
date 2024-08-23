@tool
extends PanelContainer

const LABEL_DISABLED: String = "No Section Selected"
const LABEL_NO_ITEMS: String = "No Setting Available"

@export var empty_setting: Script
@export_group("Nodes")
@export var _Core: MarginContainer
@export var _NewField: LineEdit
@export var _TemplateBtn: OptionButton
@export var _ReloadBtn: Button
@export var _List: ItemList
@export var _ListLabel: Label
@export var Subsecs: PanelContainer

var base_path: String
var _item_name_is_valid: bool


func _ready() -> void:
	_NewField.focus_exited.connect(_on_NewField_focus_exited)
	_NewField.focus_entered.connect(_on_NewField_focus_entered)
	_NewField.text_changed.connect(_on_NewField_text_changed)
	_NewField.text_submitted.connect(_on_NewField_text_submitted)
	_ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)
	_List.item_selected.connect(_on_List_item_selected)
	_List.item_activated.connect(_on_List_item_activated)
	
	set_panel_disabled(true)
	_load_templates()


func set_panel_disabled(disabled: bool) -> void:
	_NewField.clear()
	_NewField.right_icon = null
	_NewField.editable = !disabled
	_TemplateBtn.disabled = disabled
	_TemplateBtn.select(0)
	_ReloadBtn.disabled = disabled
	_List.clear()
	
	if disabled:
		_ListLabel.show()
		_ListLabel.text = LABEL_DISABLED


func _load_templates() -> void:
	_TemplateBtn.clear()
	_TemplateBtn.add_item("No Template")
	_TemplateBtn.add_separator()
	
	var templates_path: String = GGS.Pref.path_templates
	var dirs: PackedStringArray = DirAccess.get_directories_at(templates_path)
	var root_items: PackedStringArray = DirAccess.get_files_at(templates_path)
	
	var idx: int = 2
	for item: String in root_items:
		if not item.ends_with(".gd"):
			continue
		
		_TemplateBtn.add_item(item.get_basename().capitalize())
		_TemplateBtn.set_item_metadata(idx, templates_path.path_join(item))
		idx += 1
	
	for dir: String in dirs:
		if dir.begins_with("_"):
			continue
		
		_TemplateBtn.add_separator(dir.capitalize())
		idx += 1
		
		var path: String = templates_path.path_join(dir)
		var items: PackedStringArray = DirAccess.get_files_at(path)
		for item: String in items:
			if not item.ends_with(".gd"):
				continue
			
			_TemplateBtn.add_item(item.get_basename().capitalize())
			_TemplateBtn.set_item_metadata(idx, path.path_join(item))
			idx += 1


#region Adding Items
func _set_item_name_valid(valid: bool) -> void:
	_item_name_is_valid = valid
	_NewField.right_icon = _Core.icon_valid if valid else _Core.icon_invalid


func _item_name_exists(item_name: String, _path_: String) -> bool:
	var path: String = _path_.path_join(item_name + ".tres")
	return FileAccess.file_exists(path)


func _validate_name(item_name: String) -> void:
	if not ggsUtils.item_name_is_valid(item_name):
		_set_item_name_valid(false)
		return
	
	if _item_name_exists(item_name, base_path):
		_set_item_name_valid(false)
		return
	
	_set_item_name_valid(true)


func _on_NewField_focus_exited() -> void:
	_NewField.right_icon = null


func _on_NewField_focus_entered() -> void:
	if not _NewField.editable:
		return
	
	var item_name: String = _NewField.text
	_validate_name(item_name)


func _on_NewField_text_changed(new_text: String) -> void:
	_validate_name(new_text)


func _create_setting(new_text: String, _path_: String) -> void:
	_NewField.clear()
	
	var path: String = _path_.path_join(new_text)
	
	if _item_name_exists(new_text, _path_):
		printerr("GGS - Mass Create Setting: Failed to create setting '%s' at '%s'. Item already exists."%[new_text, _path_])
		return
	
	var script_path: String
	if _TemplateBtn.selected == 0:
		var new_script: Script = empty_setting.duplicate()
		script_path = path + ".gd"
		ResourceSaver.save(new_script, script_path)
	else:
		script_path = _TemplateBtn.get_item_metadata(_TemplateBtn.selected)
	
	var new_setting: ggsSetting = ggsSetting.new(script_path)
	ResourceSaver.save(new_setting, path + ".tres")
	


func _on_NewField_text_submitted(new_text: String) -> void:
	if not _item_name_is_valid:
		return
	
	var selected_subsecs: PackedInt32Array = Subsecs.List.get_selected_items()
	var paths: PackedStringArray
	for subsec: int in selected_subsecs:
		paths.append(Subsecs.List.get_item_metadata(subsec))
	
	for path: String in paths:
		_create_setting(new_text, path)
	
	EditorInterface.get_resource_filesystem().scan()
	load_list()

#endregion


#region List
func load_list() -> void:
	_List.clear()
	
	var items: PackedStringArray = DirAccess.get_files_at(base_path)
	
	if items.is_empty():
		_ListLabel.show()
		_ListLabel.text = LABEL_NO_ITEMS
	else:
		_ListLabel.hide()
	
	for item: String in items:
		if not item.ends_with(".tres"):
			continue
		
		var path: String = base_path.path_join(item)
		var res: Resource = load(path)
		if res is not ggsSetting:
			continue
		
		var idx: int = _List.add_item(item.get_basename())
		_List.set_item_metadata(idx, path)


func _on_ReloadBtn_pressed() -> void:
	load_list()
	_load_templates()
	print("GGS - Reload Settings and Templates: Successful")


func _on_List_item_activated(idx: int) -> void:
	var path: String = _List.get_item_metadata(idx)
	EditorInterface.get_file_system_dock().navigate_to_path(path)


func _on_List_item_selected(idx: int) -> void:
	var path: String = _List.get_item_metadata(idx)
	var setting: ggsSetting = load(path)
	EditorInterface.inspect_object(setting)

#endregion
