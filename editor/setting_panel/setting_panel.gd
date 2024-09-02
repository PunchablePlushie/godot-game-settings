@tool
extends Control

const TEMPLATE_SCRIPT: GDScript = preload("res://addons/ggs/template.gd")

@export var Notification: AcceptDialog

@onready var AddBtn: Button = %AddBtn
@onready var NSF: LineEdit = %NewSettingField
@onready var NGF: LineEdit = %NewGroupField
@onready var CheckAllBtn: Button = %CheckAllBtn
@onready var UncheckAllBtn: Button = %UncheckAllBtn
@onready var ReloadBtn: Button = %ReloadBtn
@onready var List: ScrollContainer = %SettingList
@onready var ASW: ConfirmationDialog = $AddSettingWindow


func _ready() -> void:
	AddBtn.pressed.connect(_on_AddBtn_pressed)
	ASW.template_selected.connect(_on_ASW_template_selected)
	
	NSF.text_submitted.connect(_on_NSF_text_submitted)
	NGF.text_submitted.connect(_on_NGF_text_submitted)
	CheckAllBtn.pressed.connect(_on_CheckAllBtn_pressed)
	UncheckAllBtn.pressed.connect(_on_UncheckAllBtn_pressed)
	ReloadBtn.pressed.connect(_on_ReloadBtn_pressed)
	
	GGS.active_category_changed.connect(_on_Global_active_category_changed)
	GGS.active_setting_changed.connect(_on_Global_active_setting_changed)
	
	AddBtn.disabled = true
	NSF.editable = false
	NGF.editable = false
	CheckAllBtn.disabled = true
	UncheckAllBtn.disabled = true
	ReloadBtn.disabled = true


func _set_topbar_disabled(disabled: bool) -> void:
	AddBtn.disabled = disabled
	NSF.editable = !disabled
	NGF.editable = !disabled
	CheckAllBtn.disabled = disabled
	UncheckAllBtn.disabled = disabled
	ReloadBtn.disabled = disabled


func _on_Global_active_category_changed() -> void:
	_set_topbar_disabled(GGS.active_category.is_empty())


func _on_Global_active_setting_changed() -> void:
	var active_list_item: Button = List.btn_group.get_pressed_button()
	if GGS.active_setting == null and active_list_item != null:
		active_list_item.button_pressed = false


### Setting Creation

func _create_setting(item_name: String, template_path: String = "") -> void:
	GGS.progress_started.emit(GGS.Progress.ADD_SETTINGS)
	
	# A tiny delay so the progress_started signal can travel properly
	await get_tree().create_timer(0.05).timeout 
	
	if (
		not item_name.is_valid_filename() or
		item_name.begins_with("_") or
		item_name.begins_with(".")
	):
		Notification.purpose = Notification.Purpose.INVALID
		Notification.popup_centered()
		GGS.progress_ended.emit()
		return
	
	var paths: PackedStringArray
	var selected_groups: Array[Node] = List.get_selected_groups()
	if selected_groups.is_empty():
		var category_path: String = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
		paths.append(category_path)
	else:
		for group in selected_groups:
			paths.append(group.path)
	
	var dir: DirAccess = DirAccess.open("res://")
	for path in paths:
		dir.change_dir(path)
		
		if paths.size() == 1:
			if dir.file_exists("%s.tres"%item_name):
				Notification.purpose = Notification.Purpose.ALREADY_EXISTS
				Notification.popup_centered()
				GGS.progress_ended.emit()
				return
		else:
			if dir.file_exists("%s.tres"%item_name):
				printerr("GGS - Add Setting to Multiple Groups: An item with this name already exists. Ignoring <%s>."%path.get_file())
				continue
		
		var script: Script
		var script_path: String
		if template_path.is_empty():
			script = TEMPLATE_SCRIPT.duplicate()
			script_path = "%s/%s.gd"%[dir.get_current_dir(), item_name]
			ResourceSaver.save(script, script_path)
			script = load(script_path)
		else:
			script = load(template_path)
		
		var resource: ggsSetting = ggsSetting.new()
		var res_path: String = "%s/%s.tres"%[dir.get_current_dir(), item_name]
		resource.set_script(script)
		ResourceSaver.save(resource, res_path)
	
	NSF.clear()
	ggsUtils.get_resource_file_system().scan()
	List.load_list()
	GGS.progress_ended.emit()


func _on_NSF_text_submitted(submitted_text: String) -> void:
	_create_setting(submitted_text)


### Group Creation

func _create_group(group_name: String) -> void:
	if (
		not group_name.is_valid_filename() or
		group_name.begins_with("_") or
		group_name.begins_with(".")
	):
		Notification.purpose = Notification.Purpose.INVALID
		Notification.popup_centered()
		return
	
	var path: String = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
	var dir: DirAccess = DirAccess.open(path)
	if dir.dir_exists(group_name):
		Notification.purpose = Notification.Purpose.ALREADY_EXISTS
		Notification.popup_centered()
		return
	
	dir.make_dir(group_name)
	
	NGF.clear()
	ggsUtils.get_resource_file_system().scan()
	List.load_list()


func _on_NGF_text_submitted(submitted_text: String) -> void:
	_create_group(submitted_text)


### Setting from Template

func _on_AddBtn_pressed() -> void:
	ASW.popup_centered()


func _on_ASW_template_selected(template: String, setting_name: String) -> void:
	_create_setting(setting_name, template)


### Check/Uncheck Btns

func _on_CheckAllBtn_pressed() -> void:
	List.set_checked_all(true)


func _on_UncheckAllBtn_pressed() -> void:
	List.set_checked_all(false)


### Reload Btn

func _on_ReloadBtn_pressed() -> void:
	List.load_list()

