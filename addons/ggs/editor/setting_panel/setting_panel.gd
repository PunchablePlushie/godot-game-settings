@tool
extends Control

const TEMPLATE_SCRIPT: GDScript = preload("res://addons/ggs/template.gd")

@export var Notification: AcceptDialog

@onready var AddBtn: Button = %AddBtn
@onready var NSF: LineEdit = %NewSettingField
@onready var NGF: LineEdit = %NewGroupField
@onready var CollapseAllBtn: Button = %CollapseAllBtn
@onready var ExpandAllBtn: Button = %ExpandAllBtn
@onready var ReloadBtn: Button = %ReloadBtn
@onready var List: Tree = %SettingList
@onready var ASW: ConfirmationDialog = $AddSettingWindow


func _ready() -> void:
	AddBtn.pressed.connect(_on_AddBtn_pressed)
	ASW.template_selected.connect(_on_ASW_template_selected)
	
	NSF.text_submitted.connect(_on_NSF_text_submitted)
	NGF.text_submitted.connect(_on_NGF_text_submitted)
	CollapseAllBtn.pressed.connect(_on_CollapseAllBtn_pressed)
	ExpandAllBtn.pressed.connect(_on_ExpandAllBtn_pressed)
	ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)
	
	GGS.active_category_updated.connect(_on_Global_active_category_updated)


func _create_item(item_name: String, creation_method: Callable) -> void:
	if (
		not item_name.is_valid_filename() or
		item_name.begins_with("_") or
		item_name.begins_with(".") or
		item_name.begins_with("-")
	):
		Notification.purpose = Notification.Purpose.INVALID
		Notification.popup_centered()
		return
	
	var path: String
	var selected_item: TreeItem = List.get_selected()
	if selected_item == null or not selected_item.get_metadata(0)["is_group"]:
		path = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
	else:
		path = selected_item.get_metadata(0)["path"]
	
	if creation_method == _create_group:
		item_name = item_name.insert(0, "-")
	
	var dir: DirAccess = DirAccess.open(path)
	if dir.dir_exists(item_name):
		Notification.purpose = Notification.Purpose.ALREADY_EXISTS
		Notification.popup_centered()
		return
	
	creation_method.call(item_name, path)
	ggsUtils.get_resource_file_system().scan()
	List.load_list()


func _set_topbar_disabled(disabled: bool) -> void:
	AddBtn.disabled = disabled
	NSF.editable = !disabled
	NGF.editable = !disabled
	CollapseAllBtn.disabled = disabled
	ExpandAllBtn.disabled = disabled
	ReloadBtn.disabled = disabled


func _on_Global_active_category_updated() -> void:
	_set_topbar_disabled(GGS.active_category.is_empty())


### Setting Creation

func _create_setting(setting_name: String, path: String) -> void:
	var dir: DirAccess = DirAccess.open(path)
	dir.make_dir(setting_name)
	
	var setting_dir: String = path.path_join(setting_name)
	var script: GDScript = TEMPLATE_SCRIPT.duplicate()
	var script_path: String = "%s/%s.gd"%[setting_dir, setting_name]
	ResourceSaver.save(script, script_path)
	
	var resource: ggsSetting = ggsSetting.new()
	script = load(script_path)
	resource.set_script(script)
	ResourceSaver.save(resource, "%s/%s.tres"%[setting_dir, setting_name])
	
	NSF.clear()


func _on_NSF_text_submitted(submitted_text: String) -> void:
	_create_item(submitted_text, _create_setting)


### Group Creation

func _create_group(group_name: String, path: String) -> void:
	var dir: DirAccess = DirAccess.open(path)
	dir.make_dir(group_name)
	NGF.clear()


func _on_NGF_text_submitted(submitted_text: String) -> void:
	_create_item(submitted_text, _create_group)


### Setting from Template

func _create_from_template(setting_name: String, path: String, template: String) -> void:
	var dir: DirAccess = DirAccess.open(path)
	dir.make_dir(setting_name)
	
	var setting_dir: String = path.path_join(setting_name)
	var script_path: String = ggsUtils.get_plugin_data().dir_templates.path_join(template)
	
	var resource: ggsSetting = ggsSetting.new()
	var script: GDScript = load(script_path)
	resource.set_script(script)
	ResourceSaver.save(resource, "%s/%s.tres"%[setting_dir, setting_name])


func _on_AddBtn_pressed() -> void:
	ASW.popup_centered()


func _on_ASW_template_selected(template: String, setting_name: String) -> void:
	_create_item(setting_name, _create_from_template.bind(template))


### Collapse/Expand Btns

func _on_CollapseAllBtn_pressed() -> void:
	List.set_collapsed_all(true)


func _on_ExpandAllBtn_pressed() -> void:
	List.set_collapsed_all(false)


### Reload Btn

func _on_ReloadBtn_pressed() -> void:
	List.load_list()

