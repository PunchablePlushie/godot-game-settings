@tool
extends EditorInspectorPlugin
class_name ggsInspectorPlugin

var input_selector_scn: PackedScene = preload("./input_selector/input_selector.tscn")
const TYPE_SELECTOR_SCN: PackedScene = preload("./type_selector/type_selector.tscn")
const HINT_SELECTOR_SCN: PackedScene = preload("./hint_selector/hint_selector.tscn")
const HINT_STRING_FIELD_SCN: PackedScene = preload("./hint_string_field/hint_string_field.tscn")
const TEMPLATE_SELECTOR_SCN: PackedScene = preload("./template_selector/template_selector.tscn")

func _can_handle(object: Object) -> bool:
	return object is ggsSetting


func _parse_property(object: Object, type: Variant.Type, name: String,
		hint_type: PropertyHint, hint_string: String, usage_flags: int,
		wide: bool) -> bool:
	if name == "value_type":
		add_property_editor(name, TYPE_SELECTOR_SCN.instantiate())
		return true
	
	if name == "value_hint":
		add_property_editor(name, HINT_SELECTOR_SCN.instantiate())
		return true
	
	if name == "value_hint_string":
		add_property_editor(name, HINT_STRING_FIELD_SCN.instantiate())
		return true
	
	return false


func _parse_group(object: Object, group: String) -> void:
	if group == "Setting Properties":
		add_custom_control(TEMPLATE_SELECTOR_SCN.instantiate())


func _parse_category(object: Object, category: String) -> void:
	if category != "input.gd":
		return
	
	var InputSelector: Control = input_selector_scn.instantiate()
	InputSelector.inspected_obj = object as ggsInputSetting
	add_custom_control(InputSelector)
