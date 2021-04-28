tool
extends WindowDialog
signal confirmed(setting_name, section, key)

var setting_name: String = ""
var section: String = ""
var key: String = ""

# SceneTree
onready var NameField: LineEdit = $Mrg/VBox/Name/LineEdit
onready var SectionField: LineEdit = $Mrg/VBox/Section/LineEdit
onready var KeyField: LineEdit = $Mrg/VBox/Key/LineEdit

onready var ConfirmBtn: Button = $Mrg/VBox/Buttons/Confirm
onready var CancelBtn: Button = $Mrg/VBox/Buttons/Cancel


func _process(_delta):
	if _input_is_valid():
		ConfirmBtn.disabled = false
	else:
		ConfirmBtn.disabled = true


func _on_Confirm_pressed():
	emit_signal("confirmed", NameField.text, SectionField.text, KeyField.text)
	visible = false
	_clear_input()


func _on_Cancel_pressed():
	visible = false
	_clear_input()


func _input_is_valid() -> bool:
	if NameField.text != "" and SectionField.text != "" and KeyField.text != "":
		return true
	else:
		return false


func _clear_input() -> void:
	NameField.text = ""
	SectionField.text = ""
	KeyField.text = ""
