@tool
extends ConfirmationDialog

signal delete_confirmed(item_name: String, is_permanent: bool)

@export_group("Text", "text_")
@export_multiline var _text_regular: String
@export_multiline var _text_perma_delete: String

@export_group("Nodes")
@export var _DialogText: Label
@export var _CheckBtn: CheckBox

var item_name: String


func _init() -> void:
	visible = false


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	confirmed.connect(_on_confirmed)
	_CheckBtn.toggled.connect(_on_CheckBtn_toggled)


func _set_text(perma_delete: bool) -> void:
	_DialogText.text = _text_perma_delete if perma_delete else _text_regular
	_DialogText.text = _DialogText.text.format([item_name])


func _on_visibility_changed() -> void:
	if visible:
		_set_text(_CheckBtn.button_pressed)
		get_cancel_button().grab_focus()


func _on_confirmed() -> void:
	delete_confirmed.emit(item_name, _CheckBtn.button_pressed)


func _on_CheckBtn_toggled(toggled_on: bool) -> void:
	_set_text(toggled_on)
