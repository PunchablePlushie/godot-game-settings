@tool
extends ConfirmationDialog

signal rename_confirmed(prev_name: String, new_name: String)

@export_group("Nodes")
@export var CurField: LineEdit
@export var NewField: LineEdit

var prev_name: String


func _ready() -> void:
	get_ok_button().pressed.connect(_on_OkBtn_pressed)
	NewField.text_submitted.connect(_on_NewField_text_submitted)
	visibility_changed.connect(_on_visibility_changed)
	GGS.Event.notif_popup_closed.connect(_on_Global_notif_popup_closed)
	
	popup_centered(min_size)


func _attempt_confirm(new_name: String) -> void:
	if not GGS.Util.item_name_validate(new_name):
		return
	
	rename_confirmed.emit(prev_name, new_name)
	hide()


func _on_NewField_text_submitted(submitted_text: String) -> void:
	_attempt_confirm(submitted_text)


func _on_OkBtn_pressed() -> void:
	_attempt_confirm(NewField.text)


func _on_visibility_changed() -> void:
	if visible:
		CurField.text = prev_name
		NewField.grab_focus()
	
	if not visible:
		queue_free()


func _on_Global_notif_popup_closed() -> void:
	grab_focus()
	NewField.grab_focus()
	NewField.select_all()
