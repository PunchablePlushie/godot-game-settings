@tool
extends LineEdit


func _ready() -> void:
	visible = ggsPluginPref.new().get_config("HIDE_UI_categories_addfield")
