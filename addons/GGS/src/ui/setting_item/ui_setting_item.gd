tool
extends HBoxContainer

var initialized: bool = false

# SceneTree
onready var NameField: LineEdit = $NameField
onready var SectionField: LineEdit = $HBox/SectionField
onready var KeyField: LineEdit = $HBox/KeyField
onready var DefaultField: LineEdit = $HBox/DefaultField
onready var EditScriptBtn: Button = $HBox/EditScript
onready var AddScriptBtn: Button = $HBox/AddScript
onready var RemoveBtn: Button = $HBox/Remove


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

