@tool
extends EditorInspectorPlugin
class_name ggsInspectorPlugin

const TYPE_SELECTOR_SCN: PackedScene = preload("./type_selector/type_selector.tscn")
const HINT_SELECTOR_SCN: PackedScene = preload("./hint_selector/hint_selector.tscn")
const HINT_STRING_FIELD_SCN: PackedScene = preload("./hint_string_field/hint_string_field.tscn")
const INPUT_SELECTOR_SCN: PackedScene = preload("./input_selector/input_selector.tscn")


func _can_handle(object: Object) -> bool:
	return object is ggsSetting


func _parse_property(
		object: Object, type: Variant.Type, name: String,
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

	if (
		object is settingInput
		and name == "action"
	):
		add_property_editor(name, INPUT_SELECTOR_SCN.instantiate())
		return true

	return false
