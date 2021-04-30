tool
extends LineEdit

onready var Root: HBoxContainer = get_node("..")


func _ready() -> void:
	hint_tooltip = "Setting Name"


func _on_NameField_text_entered(new_text: String) -> void:
	if Root.initialized == false:
		Root.DefaultField.grab_focus()
		Root.DefaultField.editable = true
	else:
		release_focus()
	ggsManager.settings_data[str(Root.get_index())]["name"] = new_text
	ggsManager.save_settings_data()

