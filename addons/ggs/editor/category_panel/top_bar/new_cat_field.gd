@tool
extends LineEdit


func _ready() -> void:
	placeholder_text = ggsUtils.get_plugin_text("categories", "field_placeholder")
