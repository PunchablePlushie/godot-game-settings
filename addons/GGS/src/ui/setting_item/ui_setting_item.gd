tool
extends HBoxContainer

var initialized: bool = false

# SceneTree
onready var NameField: LineEdit = $NameField
onready var SectionField: LineEdit = $HBox/SectionField
onready var KeyField: LineEdit = $HBox/KeyField
onready var EditScriptBtn: Button = $HBox/EditScript
onready var AddScriptBtn: Button = $HBox/AddScript
onready var RemoveBtn: Button = $HBox/Remove
onready var ConfirmDialog: ConfirmationDialog = $ConfirmDialog


func _ready() -> void:
	EditScriptBtn.hint_tooltip = "Edit Script"
	AddScriptBtn.hint_tooltip = "Assign/Change Script"
	RemoveBtn.hint_tooltip = "Remove Setting"


func _on_AddScript_pressed() -> void:
	var path: String = ggsManager.ggs_data["default_logic_path"]
	var Editor: EditorPlugin = EditorPlugin.new()
	var dialog: ScriptCreateDialog = Editor.get_script_create_dialog()
	dialog.dialog_hide_on_ok = true
	dialog.window_title = "Create a New Logic Script"
	if not dialog.is_connected("script_created", self, "_on_dialog_closed"):
		dialog.connect("script_created", self, "_on_dialog_closed", [], CONNECT_ONESHOT)
	dialog.config("Node", "%s%s"%[path, NameField.text])
	dialog.popup_centered()


func _on_dialog_closed(script: Script) -> void:
	ggsManager.settings_data[str(get_index())]["logic"] = script.resource_path
	
	ggsManager.save_as_json(ggsManager.settings_data, ggsManager.SETTINGS_DATA_PATH)
	EditScriptBtn.text = ggsManager.settings_data[str(get_index())]["logic"]
	EditScriptBtn.disabled = false
	if initialized == false:
		initialized = true


func _on_EditScript_pressed() -> void:
	var Editor: EditorPlugin = EditorPlugin.new()
	var path: String = ggsManager.settings_data[str(get_index())]["logic"]
	if path != "":
		if ResourceLoader.exists(path):
			var resource = load(path)
			Editor.get_editor_interface().edit_resource(resource)
		else:
			push_error("GGS: Could not find the script at '%s'."%[path])
	else:
		push_warning("GGS: No script is assigned to '%s'."%[name])


func _on_Remove_pressed() -> void:
	ConfirmDialog.popup_centered()


func _on_ConfirmDialog_confirmed() -> void:
	queue_free()


func _on_NameField_text_entered(new_text: String) -> void:
	if initialized == false:
		SectionField.grab_focus()
		SectionField.editable = true
	else:
		NameField.release_focus()
	ggsManager.settings_data[str(get_index())]["name"] = new_text
	ggsManager.save_as_json(ggsManager.settings_data, ggsManager.SETTINGS_DATA_PATH)


func _on_SectionField_text_entered(new_text: String) -> void:
	if initialized == false:
		KeyField.grab_focus()
		KeyField.editable = true
	else:
		SectionField.release_focus()
	ggsManager.settings_data[str(get_index())]["section"] = new_text
	ggsManager.save_as_json(ggsManager.settings_data, ggsManager.SETTINGS_DATA_PATH)


func _on_KeyField_text_entered(new_text: String) -> void:
	if initialized == false:
		AddScriptBtn.grab_focus()
		AddScriptBtn.disabled = false
	else:
		KeyField.release_focus()
	ggsManager.settings_data[str(get_index())]["key"] = new_text
	ggsManager.save_as_json(ggsManager.settings_data, ggsManager.SETTINGS_DATA_PATH)

