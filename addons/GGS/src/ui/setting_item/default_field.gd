tool
extends LineEdit

onready var Root: HBoxContainer = get_node("../..")


func _ready() -> void:
	hint_tooltip = "Default Value"


func _on_DefaultField_text_entered(new_text: String) -> void:
	if Root.initialized == false:
		Root.AddScriptBtn.grab_focus()
		Root.AddScriptBtn.disabled = false
	else:
		release_focus()
	ggsManager.settings_data[str(Root.get_index())]["default"] = new_text
	ggsManager.save_settings_data()

