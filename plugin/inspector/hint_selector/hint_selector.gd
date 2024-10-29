@tool
extends EditorProperty

const PROPERTY: StringName = "value_hint"

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
	var hint: PropertyHint = _obj.get(PROPERTY)
	_Btn.text = ggsUtils.ALL_HINTS[hint]
	_Btn.tooltip_text = _Btn.text
	_Value.text = str(hint)


func _on_Btn_pressed() -> void:
	var type: Variant.Type = _obj.get("value_type")
	var HintWin: ConfirmationDialog = _window_scn.instantiate()
	var compatible_hints = ggsUtils.type_get_compatible_hints(type)
	HintWin.hint_confirmed.connect(_on_HintWin_confirmed)
	HintWin.List.init_list(compatible_hints)
	add_child(HintWin)
	HintWin.popup_centered()


func _on_HintWin_confirmed(hint: PropertyHint) -> void:
	_obj.set(PROPERTY, hint)
	emit_changed(PROPERTY, hint)

	var type: Variant.Type = _obj.get("value_type")
	_obj.default = ggsUtils.TYPE_DEFAULTS[type]
	_obj.value_hint_string = "0,1" if (hint == PROPERTY_HINT_RANGE) else ""
	_obj.notify_property_list_changed()

	_update_controls()
