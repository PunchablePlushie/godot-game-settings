@tool
extends LineEdit


func _ready() -> void:
	text = ggsUtils.get_plugin_text("categories", "panel_label")
