@tool
extends EditorProperty

@export var window_scn: PackedScene
@export_group("Nodes")
@export var Btn: Button
@export var Value: Label

@onready var obj: ggsSetting = get_edited_object()
@onready var property: StringName = get_edited_property()


func _ready() -> void:
	Btn.pressed.connect(_on_Btn_pressed)
	_update_controls()


func _update_controls() -> void:
	var type: Variant.Type = obj.get(property)
	Btn.text = ggsUtils.ALL_TYPES[type]
	Btn.icon = ggsUtils.type_get_icon(type)
	Btn.tooltip_text = Btn.text
	Value.text = str(type)


func _on_Btn_pressed() -> void:
	var TypeWin: ConfirmationDialog = window_scn.instantiate()
	TypeWin.type_confirmed.connect(_on_TypeWin_confirmed)
	add_child(TypeWin)
	TypeWin.popup()


func _on_TypeWin_confirmed(type: Variant.Type) -> void:
	obj.set(property, type)
	emit_changed(property, type)
	
	obj.default = ggsUtils.TYPE_DEFAULTS[type]
	obj.value_hint = PROPERTY_HINT_NONE
	obj.value_hint_string = ""
	obj.notify_property_list_changed()
	
	_update_controls()
