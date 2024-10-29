@tool
extends EditorProperty

const PROPERTY: StringName = "value_type"

@export var _window_scn: PackedScene
@export_group("Nodes")
@export var _Btn: Button
@export var _Value: Label

@onready var _obj: ggsSetting = get_edited_object()


func _ready() -> void:
	if read_only:
		_Btn.disabled = true

	_Btn.pressed.connect(_on_Btn_pressed)
	_update_controls()


func _update_controls() -> void:
	var type: Variant.Type = _obj.get(PROPERTY)
	_Btn.text = ggsUtils.ALL_TYPES[type]
	_Btn.icon = ggsUtils.type_get_icon(type)
	_Btn.tooltip_text = _Btn.text
	_Value.text = str(type)


func _on_Btn_pressed() -> void:
	var TypeWin: ConfirmationDialog = _window_scn.instantiate()
	TypeWin.type_confirmed.connect(_on_TypeWin_confirmed)
	add_child(TypeWin)
	TypeWin.popup_centered()


func _on_TypeWin_confirmed(type: Variant.Type) -> void:
	_obj.set(PROPERTY, type)
	emit_changed(PROPERTY, type)

	_obj.default = ggsUtils.TYPE_DEFAULTS[type]
	_obj.value_hint = PROPERTY_HINT_NONE
	_obj.value_hint_string = ""
	_obj.notify_property_list_changed()

	_update_controls()
