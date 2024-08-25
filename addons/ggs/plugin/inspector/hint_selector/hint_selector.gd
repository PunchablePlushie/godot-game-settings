@tool
extends EditorProperty

const PROPERTY: StringName = "value_hint"

@export_group("Nodes")
@export var Btn: Button
@export var Value: Label

@onready var obj: ggsSetting = get_edited_object()


func _ready() -> void:
	Btn.pressed.connect(_on_Btn_pressed)
	GGS.hint_selector_confirmed.connect(_on_Global_hint_selector_confirmed)
	
	_update_controls()


func _update_controls() -> void:
	var hint: PropertyHint = obj.get(PROPERTY)
	Btn.text = ggsUtils.ALL_HINTS[hint]
	Btn.tooltip_text = Btn.text
	Value.text = str(hint)


func _on_Btn_pressed() -> void:
	var type: Variant.Type = obj.get("value_type")
	GGS.hint_selector_requested.emit(type)


func _on_Global_hint_selector_confirmed(hint: PropertyHint) -> void:
	obj.set(PROPERTY, hint)
	emit_changed(PROPERTY, hint)
	
	var type: Variant.Type = obj.get("value_type")
	obj.default = ggsUtils.TYPE_DEFAULTS[type]
	obj.value_hint_string = "0,1" if (hint == PROPERTY_HINT_RANGE) else ""
	obj.notify_property_list_changed()
	
	_update_controls()
