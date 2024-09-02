@tool
extends Window

enum DirTarget {SETTINGS, COMPONENTS, TEMPLATES}
enum ConfirmPurpose {RESET, OK}

const THEME: Theme = preload("res://addons/ggs/editor/_theme/ggs_theme.tres")
const TEMPLATE: Script = preload("res://addons/ggs/template.gd")
const GGS_SCENE: String = "res://addons/ggs/classes/global/ggs.tscn"

@export_multiline var reset_text: String
@export_multiline var ok_text: String

@onready var OkBtn: Button = %OkBtn
@onready var CancelBtn: Button = %CancelBtn

@onready var SDF: LineEdit = %SettingDirField
@onready var CDF: LineEdit = %CompDirField
@onready var TDF: LineEdit = %TemplatesDirField
@onready var SFNF: LineEdit = %SaveFileNameField
@onready var SFEF: LineEdit = %SaveFileExtensionField

@onready var SDB: Button = %SettingDirBtn
@onready var CDB: Button = %CompDirBtn
@onready var TDB: Button = %TemplatesDirBtn
@onready var DSW: FileDialog = $DirSelectionWindow

@onready var ApplyOnChanged: CheckBox = %ApplyOnChanged
@onready var GrabFocusOnMouseOver: CheckBox = %GrabFocusOnMouseOver
@onready var SetSFXBtn: Button = %SetSFXBtn

@onready var UpdateThemeBtn: Button = %UpdateThemeBtn
@onready var BaseTemplateBtn: Button = %BaseTemplateBtn
@onready var ResetBtn: Button = %ResetBtn
@onready var CRW: ConfirmationDialog = $ConfirmWindow

@onready var VersionBtn: Button = %VersionBtn
@onready var ChangelogBtn: Button = %ChangelogBtn


func _ready() -> void:
	about_to_popup.connect(_on_about_to_popup)
	close_requested.connect(_on_close_requested)
	CancelBtn.pressed.connect(_on_close_requested)
	OkBtn.pressed.connect(_on_OkBtn_pressed)
	
	SDB.pressed.connect(_on_AnyDirectoryBtn_pressed.bind(SDB))
	CDB.pressed.connect(_on_AnyDirectoryBtn_pressed.bind(CDB))
	TDB.pressed.connect(_on_AnyDirectoryBtn_pressed.bind(TDB))
	DSW.dir_selected.connect(_on_DSW_dir_selected)
	
	UpdateThemeBtn.pressed.connect(_on_UpdateThemeBtn_pressed)
	BaseTemplateBtn.pressed.connect(_on_BaseTemplateBtn_pressed)
	ResetBtn.pressed.connect(_on_ResetBtn_pressed)
	CRW.confirmed.connect(_on_CRW_confirmed)
	
	SetSFXBtn.pressed.connect(_on_SetSFXBtn_pressed)
	
	VersionBtn.pressed.connect(_on_VersionBtn_pressed)
	ChangelogBtn.pressed.connect(_on_ChangelogBtn_pressed)
	
	hide()


### Info Buttons

func _on_VersionBtn_pressed() -> void:
	var URI: String = "https://github.com/PunchablePlushie/godot-game-settings/releases"
	OS.shell_open(URI)


func _on_ChangelogBtn_pressed() -> void:
	var URI: String = "https://github.com/PunchablePlushie/godot-game-settings/tree/main/docs/changelog.md"
	OS.shell_open(URI)


### Fields

func _init_values() -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	SDF.text = data.dir_settings
	CDF.text = data.dir_components
	TDF.text = data.dir_templates
	ApplyOnChanged.button_pressed = data.apply_on_changed_all
	GrabFocusOnMouseOver.button_pressed = data.grab_focus_on_mouse_over_all
	
	var value: String = data.dir_save_file
	SFNF.text = value.get_file().get_basename()
	SFEF.text = value.get_extension()


func _on_AnyDirectoryBtn_pressed(src: Button) -> void:
	var target: String
	
	match src:
		SDB:
			DSW.set_meta("target", DirTarget.SETTINGS)
		CDB:
			DSW.set_meta("target", DirTarget.COMPONENTS)
		TDB:
			DSW.set_meta("target", DirTarget.TEMPLATES)
	
	DSW.invalidate()
	DSW.popup_centered()


func _on_DSW_dir_selected(dir: String) -> void:
	var target_field: LineEdit
	match DSW.get_meta("target"):
		DirTarget.SETTINGS:
			target_field = SDF
		DirTarget.COMPONENTS:
			target_field = CDF
		DirTarget.TEMPLATES:
			target_field = TDF
	
	target_field.text = dir


### Buttons

func _on_SetSFXBtn_pressed() -> void:
	ggsUtils.get_editor_interface().open_scene_from_path(GGS_SCENE)
	hide()


func _on_UpdateThemeBtn_pressed() -> void:
	THEME.update()


func _on_BaseTemplateBtn_pressed() -> void:
	ggsUtils.get_editor_interface().inspect_object(TEMPLATE)
	hide()


func _on_ResetBtn_pressed() -> void:
	CRW.dialog_text = reset_text
	CRW.set_meta("purpose", ConfirmPurpose.RESET)
	CRW.popup_centered()


func _on_OkBtn_pressed() -> void:
	CRW.dialog_text = ok_text
	CRW.set_meta("purpose", ConfirmPurpose.OK)
	CRW.popup_centered()


func _on_CRW_confirmed() -> void:
	match CRW.get_meta("purpose"):
		ConfirmPurpose.RESET:
			ggsUtils.get_plugin_data().reset()
			
			hide()
			ggsUtils.get_editor_interface().set_plugin_enabled("ggs", false)
		ConfirmPurpose.OK:
			var data: ggsPluginData = ggsUtils.get_plugin_data()
			data.set_property("dir_settings", SDF.text)
			data.set_property("dir_components", CDF.text)
			data.set_property("dir_templates", TDF.text)
			data.set_property("apply_on_changed_all", ApplyOnChanged.button_pressed)
			data.set_property("grab_focus_on_mouse_over_all", GrabFocusOnMouseOver.button_pressed)
			
			var value: String = "user://%s.%s"%[SFNF.text, SFEF.text]
			data.set_property("dir_save_file", value)
			
			hide()
			ggsUtils.get_editor_interface().set_plugin_enabled("ggs", false)


### Window Functionalities

func _on_about_to_popup() -> void:
	_init_values()


func _on_close_requested() -> void:
	hide()
