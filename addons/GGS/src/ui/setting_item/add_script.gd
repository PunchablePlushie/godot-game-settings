tool
extends Button

onready var EditScriptBtn: Button = get_node("../EditScript")
onready var NameField: LineEdit = get_node("../../NameField")
onready var Root: HBoxContainer = get_node("../..")


func _ready() -> void:
	hint_tooltip = "Assign/Change Script"


func _on_AddScript_pressed() -> void:
	var path: String = ggsManager.ggs_data["default_logic_path"]
	
	var Editor: EditorPlugin = EditorPlugin.new()
	var dialog: ScriptCreateDialog = Editor.get_script_create_dialog()
	dialog.dialog_hide_on_ok = true
	dialog.window_title = "Create a New Logic Script"
	if not dialog.is_connected("script_created", self, "_on_ScriptCreateDialog_closed"):
		dialog.connect("script_created", self, "_on_ScriptCreateDialog_closed", [], CONNECT_ONESHOT)
	dialog.config("Node", "%s%s"%[path, NameField.text])
	
	dialog.popup_centered()


func _on_ScriptCreateDialog_closed(script: Script) -> void:
	ggsManager.settings_data[str(Root.get_index())]["logic"] = script.resource_path
	ggsManager.save_settings_data()
	
	var path: String = ggsManager.settings_data[str(Root.get_index())]["logic"]
	EditScriptBtn.hint_tooltip = "%s: %s"%[EditScriptBtn.BASE_TOOLTIP ,path]
	EditScriptBtn.disabled = false
	if Root.initialized == false:
		Root.initialized = true
	
	print("GGS - %02d: Script assigned (%s)"%[Root.get_index(), path])
	EditScriptBtn.broken = false
