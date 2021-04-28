tool
extends HBoxContainer

# SceneTree
onready var SettingName: Label = $Name
onready var EditBtn: Button = $HBox/Edit
onready var EditScriptBtn: Button = $HBox/EditScript
onready var AddScriptBtn: Button = $HBox/AddScript
onready var RemoveBtn: Button = $HBox/Remove
onready var FileDial: FileDialog = $FileDialog


func _ready() -> void:
	EditBtn.hint_tooltip = "Edit Properties"
	EditScriptBtn.hint_tooltip = "Edit the logic script"
	AddScriptBtn.hint_tooltip = "Define a logic script"
	RemoveBtn.hint_tooltip = "Remove"


func _on_AddScript_pressed() -> void:
	FileDial.popup_centered()
	FileDial.current_path = ggsManager.ggs_data["default_logic_path"]
	FileDial.current_file = "%s.gd"%[name]


func _on_FileDialog_file_selected(path: String) -> void:
	var file: File = File.new()
	var err: int = file.open(path, File.WRITE)
	if err == OK:
		file.store_string("extends Node\n")
		file.close()
	ggsManager.settings_data[name]["logic"] = path
	ggsManager.save_as_json(ggsManager.settings_data, ggsManager.SETTINGS_DATA_PATH)
	EditScriptBtn.disabled = false


func _on_EditScript_pressed() -> void:
	var Editor: EditorPlugin = EditorPlugin.new()
	var path: String = ggsManager.settings_data[name]["logic"]
	if path != "":
		var resource = load(path)
		Editor.get_editor_interface().edit_resource(resource)
	else:
		push_warning("GGS: No script is assigned.")
