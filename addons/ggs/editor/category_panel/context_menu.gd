@tool
extends PopupMenu

var icon_delete: Texture2D = ggsUtils.get_editor_icon("Remove")
var icon_inspect: Texture2D = ggsUtils.get_editor_icon("Search")
var label_delete: String = ggsUtils.get_plugin_text("categories", "context_delete")
var label_inspect: String = ggsUtils.get_plugin_text("categories", "context_inspect")

func _ready() -> void:
	clear()
	add_icon_item(icon_delete, label_delete)
	add_icon_item(icon_inspect, label_inspect)
