tool
extends OptionButton

onready var Root: HBoxContainer = get_node("../..")


func _ready() -> void:
	text = ""
	hint_tooltip = "Value Type"


func _on_DefaultType_item_selected(index: int) -> void:
	text = ""
	if Root.initialized == false:
		Root.DefaultField.grab_focus()
	
	ggsManager.settings_data[str(Root.get_index())]["value_type"] = index
	ggsManager.save_settings_data()
	
	ggsManager.print_notif("%02d"%[Root.get_index()], "Item type selected (%d)"%[index])
	
	# Attempt to accept the value in the DefaultField
	Root.DefaultField._on_DefaultField_text_entered(Root.DefaultField.text)
