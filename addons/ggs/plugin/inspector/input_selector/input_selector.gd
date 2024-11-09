@tool
extends EditorProperty

const PROPERTY: StringName = "action"

@export var _window_scn: PackedScene
@export_group("Nodes")
@export var _Btn: Button

@onready var _obj: settingInput = get_edited_object()


func _ready() -> void:
	_Btn.pressed.connect(_on_Btn_pressed)
	_update_controls()


func _update_controls() -> void:
	var property_value: String = _obj.get(PROPERTY)
	_Btn.text = "Select Input" if property_value.is_empty() else property_value
	_Btn.tooltip_text = _Btn.text


func _on_Btn_pressed() -> void:
	var InputWin: ConfirmationDialog = _window_scn.instantiate()
	InputWin.input_confirmed.connect(_on_InputWin_confirmed)
	add_child(InputWin)
	InputWin.popup_centered()


func _on_InputWin_confirmed(action: String) -> void:
	_obj.set(PROPERTY, action)
	emit_changed(PROPERTY, action)

	_obj.event_idx = 0
	_obj.notify_property_list_changed()

	_update_controls()
