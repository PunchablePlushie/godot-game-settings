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
#	AddBtn.pressed.connect(_on_AddBtn_pressed)
#	ASW.setting_selected.connect(_on_ASW_setting_selected)
	
	NSF.text_submitted.connect(_on_NSF_text_submitted)
	NGF.text_submitted.connect(_on_NGF_text_submitted)
#	GGS.setting_selected.connect(_on_Global_setting_selected)
	CollapseAllBtn.pressed.connect(_on_CollapseAllBtn_pressed)
	ExpandAllBtn.pressed.connect(_on_ExpandAllBtn_pressed)
	ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)


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
	if (
		not submitted_text.is_valid_filename() or
		submitted_text.begins_with("_") or
		submitted_text.begins_with(".") or
		submitted_text.begins_with("-")
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
	
	var dir: DirAccess = DirAccess.open(path)
	if dir.dir_exists(submitted_text):
		Notification.purpose = Notification.Purpose.ALREADY_EXISTS
		Notification.popup_centered()
		return
	
	_create_setting(submitted_text, path)
	ggsUtils.get_resource_file_system().scan()
	List.load_list()


### Group Creation

func _on_NGF_text_submitted(submitted_text: String) -> void:
	pass



### Collapse/Expand Btns

func _on_CollapseAllBtn_pressed() -> void:
	List.set_collapsed_all(true)


func _on_ExpandAllBtn_pressed() -> void:
	List.set_collapsed_all(false)


### Reload Btn

func _on_ReloadBtn_pressed() -> void:
	List.load_list()

