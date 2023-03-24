@tool
extends Window

@onready var OkBtn: Button = %OkBtn
@onready var CancelBtn: Button = %CancelBtn

@onready var SDF: LineEdit = %SettingDirField
@onready var CDF: LineEdit = %CompDirField
@onready var SFDF: LineEdit = %SaveFileDirField

@onready var SDB: Button = %SettingDirBtn
@onready var CDB: Button = %CompDirBtn
@onready var SFDB: Button = %SaveFileDirBtn
@onready var DSW: FileDialog = $DirSelectionWndw

@onready var ResetBtn: Button = %ResetBtn
@onready var CRW: ConfirmationDialog = $ConfirmResetWndw


func _ready() -> void:
	about_to_popup.connect(_on_about_to_popup)
	close_requested.connect(_on_close_requested)
	CancelBtn.pressed.connect(_on_close_requested)
	OkBtn.pressed.connect(_on_OkBtn_pressed)
	
	SDB.pressed.connect(_on_AnyDirectoryBtn_pressed.bind(SDB))
	CDB.pressed.connect(_on_AnyDirectoryBtn_pressed.bind(CDB))
	SFDB.pressed.connect(_on_AnyDirectoryBtn_pressed.bind(SFDB))
	DSW.dir_selected.connect(_on_DSW_dir_selected)
	DSW.file_selected.connect(_on_DSW_file_selected)
	
	ResetBtn.pressed.connect(_on_ResetBtn_pressed)
	CRW.confirmed.connect(_on_CRW_confirmed)
	
	hide()


### Fields

func _init_fields() -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	SDF.text = data.dir_settings
	CDF.text = data.dir_components
	SFDF.text = data.dir_save_file


func _on_AnyDirectoryBtn_pressed(src: Button) -> void:
	var target: String
	match src:
		SDB:
			DSW.file_mode = FileDialog.FILE_MODE_OPEN_DIR
			DSW.access = FileDialog.ACCESS_RESOURCES
			DSW.set_meta("Target", "Settings")
		CDB:
			DSW.file_mode = FileDialog.FILE_MODE_OPEN_DIR
			DSW.access = FileDialog.ACCESS_RESOURCES
			DSW.set_meta("Target", "Components")
		SFDB:
			DSW.file_mode = FileDialog.FILE_MODE_OPEN_FILE
			DSW.access = FileDialog.ACCESS_USERDATA
	
	DSW.invalidate()
	DSW.popup_centered()


func _on_DSW_dir_selected(dir: String) -> void:
	var target_field: LineEdit
	match DSW.get_meta("Target"):
		"Settings":
			target_field = SDF
		"Components":
			target_field = CDF
	
	target_field.text = dir


func _on_DSW_file_selected(file: String) -> void:
	SFDF.text = file


### Reseting

func _on_ResetBtn_pressed() -> void:
	CRW.popup_centered()


func _on_CRW_confirmed() -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	data.reset()
	hide()
	ggsUtils.get_editor_interface().set_plugin_enabled("ggs", false)


### Window Functionalities

func _on_about_to_popup() -> void:
	_init_fields()


func _on_close_requested() -> void:
	hide()


func _on_OkBtn_pressed() -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	data.set_data("dir_settings", SDF.text)
	data.set_data("dir_components", CDF.text)
	data.set_data("dir_save_file", SFDF.text)
	hide()
	ggsUtils.get_editor_interface().set_plugin_enabled("ggs", false)
