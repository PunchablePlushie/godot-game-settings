@tool
extends EditorInspectorPlugin
class_name ggsInspectorPlugin

var input_selector_scn: PackedScene = preload("res://addons/ggs/editor/input_selector/input_selector.tscn")


func _can_handle(object: Object) -> bool:
	return object is ggsInputSetting


func _parse_category(object: Object, category: String) -> void:
	if category != "input.gd":
		return
	
	var InputSelector: Control = input_selector_scn.instantiate()
	InputSelector.inspected_obj = object as ggsInputSetting
	add_custom_control(InputSelector)
