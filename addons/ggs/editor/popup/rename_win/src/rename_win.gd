@tool
extends ConfirmationDialog

@export_group("Nodes")
@export var _CurField: LineEdit
@export var _NewField: LineEdit

var _item_type: ggsCore.ItemType
var _prev_name: String


func _init() -> void:
	visible = false


func _ready() -> void:
	get_ok_button().pressed.connect(_on_OkBtn_pressed)
	_NewField.text_submitted.connect(_on_NewField_text_submitted)
	GGS.Event.notif_closed.connect(_on_Global_notif_closed)
	GGS.Event.rename_requested.connect(_on_Global_rename_requested)


func _attempt_confirm(new_name: String) -> void:
	if not GGS.Util.validate_item_name(_item_type, new_name):
		return
	
	hide()
	GGS.Event.rename_confirmed.emit(_item_type, _prev_name, new_name)


func _on_NewField_text_submitted(submitted_text: String) -> void:
	_attempt_confirm(submitted_text)


func _on_OkBtn_pressed() -> void:
	_attempt_confirm(_NewField.text)


func _on_Global_rename_requested(item_type: ggsCore.ItemType, item_name: String) -> void:
	_item_type = item_type
	_prev_name = item_name
	_CurField.text = item_name
	_NewField.clear()
	
	popup_centered(min_size)
	_NewField.grab_focus()


func _on_Global_notif_closed(_type: ggsCore.NotifType) -> void:
	grab_focus()
	_NewField.grab_focus()
	_NewField.select_all()
