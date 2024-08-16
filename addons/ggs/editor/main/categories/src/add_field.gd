@tool
extends LineEdit

signal cat_creation_requested(cat_name: String)


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	
	visible = ggsPluginPref.new().get_config("HIDE_UI_categories_addfield")


func _on_text_submitted(submitted_text: String) -> void:
	if not GGS.Util.item_name_validate(submitted_text):
		return
	
	cat_creation_requested.emit(submitted_text)
	clear()
