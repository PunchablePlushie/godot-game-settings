tool
extends Button

onready var Root: Control = get_node("../../../..")


func _on_Create_pressed() -> void:
	var ui_item: HBoxContainer = Root.uiSettingItem.instance()
	Root.SettingsList.add_child(ui_item)
	ui_item.NameField.grab_focus()
	ui_item.RemoveBtn.connect("item_removed", Root, "_on_item_removed")
	ggsManager.settings_data[str(ui_item.get_index())] = {
		"name": "",
		"default": {},
		"current": {},
		"logic": "",
	}
	ggsManager.save_settings_data()

