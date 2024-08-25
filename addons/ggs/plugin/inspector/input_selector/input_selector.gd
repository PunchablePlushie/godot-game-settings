@tool
extends EditorProperty

const PROPERTY: String = "action"

@export var window_scn: PackedScene
@export_group("Nodes")
@export var Btn: Button

@onready var obj: settingInput = get_edited_object()


func _ready() -> void:
	Btn.pressed.connect(_on_Btn_pressed)
	_update_controls()


func _update_controls() -> void:
	var property_value: String = obj.get(PROPERTY)
	Btn.text = "Select Input" if property_value.is_empty() else property_value
	Btn.tooltip_text = Btn.text


func _on_Btn_pressed() -> void:
	var InputWin: ConfirmationDialog = window_scn.instantiate()
	InputWin.input_confirmed.connect(_on_InputWin_confirmed)
	add_child(InputWin)
	InputWin.popup()


func _on_InputWin_confirmed(action: String) -> void:
	obj.set(PROPERTY, action)
	emit_changed(PROPERTY, action)
	obj.notify_property_list_changed()
	
	_update_controls()
