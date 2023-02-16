@tool
extends Button

var tooltip: String = ggsUtils.get_plugin_text("categories", "add_btn")
var tooltip_disabled: String = ggsUtils.get_plugin_text("categories", "add_btn_disabled")


func _ready() -> void:
	disabled = true
	tooltip_text = tooltip_disabled
	icon = ggsUtils.get_editor_icon("Add")


func _set(property: StringName, value: Variant) -> bool:
	if property == "disabled":
		disabled = value
		tooltip_text = tooltip_disabled if disabled else tooltip
		return true
	
	return false
