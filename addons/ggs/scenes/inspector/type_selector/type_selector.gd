@tool
extends EditorProperty

const TOOLTIP_PREFIX: String = "Actual Value: "

@export_group("Nodes")
@export var Btn: Button

@onready var obj: ggsSetting = get_edited_object()
@onready var property: StringName = get_edited_property()


func _ready() -> void:
	Btn.pressed.connect(_on_Btn_pressed)
	GGS.Events.type_selector_confirmed.connect(_on_Global_type_selector_confirmed)
	
	var type: Variant.Type = obj.get(property)
	Btn.text = ggsUtils.get_type_string(type)
	Btn.icon = ggsUtils.get_type_icon(type)
	Btn.tooltip_text = TOOLTIP_PREFIX + str(type)


func _on_Btn_pressed() -> void:
	GGS.Events.type_selector_requested.emit()


func _on_Global_type_selector_confirmed(type: Variant.Type) -> void:
	obj.set(property, type)
	emit_changed(property, type)
	
	Btn.text = ggsUtils.get_type_string(type)
	Btn.icon = ggsUtils.get_type_icon(type)
	Btn.tooltip_text = TOOLTIP_PREFIX + str(type)
