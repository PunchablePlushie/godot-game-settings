tool
extends Button

onready var Root: HBoxContainer = get_parent()

func _ready() -> void:
	hint_tooltip = "Remove Key"


func _on_Remove_pressed() -> void:
	var default = ggsManager.settings_data[Root.index]["default"]
	
	if default.has(Root.KeyNameField.text):
		default.erase(Root.KeyNameField.text)
	ggsManager.settings_data[Root.index]["current"] = default
	ggsManager.save_settings_data()
	
	Root.queue_free()
