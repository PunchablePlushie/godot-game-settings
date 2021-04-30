tool
extends LineEdit

onready var Root: HBoxContainer = get_node("..")


func _ready() -> void:
	hint_tooltip = "Setting Name"


func _on_NameField_text_entered(new_text: String) -> void:
	if Root.initialized == false:
		Root.DefaultType.grab_focus()
	ggsManager.settings_data[str(Root.get_index())]["name"] = new_text
	ggsManager.save_settings_data()
	
	print("GGS - %02d: Name saved ('%s')"%[Root.get_index(), new_text])

