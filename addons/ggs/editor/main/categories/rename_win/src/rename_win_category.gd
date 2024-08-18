@tool
extends ConfirmationDialog

signal rename_confirmed(prev_name: String, new_name: String)

const _TYPE: ggsCore.ItemType = ggsCore.ItemType.CATEGORY

@export_group("Nodes")
@export var _DialogText: Label
@export var _Field: LineEdit

var item_name: String


func _init() -> void:
	visible = false


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	get_ok_button().pressed.connect(_on_OkBtn_pressed)
	_Field.text_submitted.connect(_on_NewField_text_submitted)
	GGS.Event.notif_closed.connect(_on_Global_notif_closed)


func _attempt_confirm(new_name: String) -> void:
	if not GGS.Util.validate_item_name(_TYPE, new_name):
		return
	
	hide()
	rename_confirmed.emit(item_name, new_name)


func _on_visibility_changed() -> void:
	if visible:
		_DialogText.text = _DialogText.text.format([item_name])
		_Field.clear()
		_Field.grab_focus()


func _on_NewField_text_submitted(submitted_text: String) -> void:
	_attempt_confirm(submitted_text)


func _on_OkBtn_pressed() -> void:
	_attempt_confirm(_Field.text)


func _on_Global_notif_closed(_type: ggsCore.NotifType) -> void:
	grab_focus()
	_Field.grab_focus()
	_Field.select_all()
