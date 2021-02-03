class_name DropDownList
extends BaseComponent

onready var label: Label = $Label
onready var button: OptionButton = $OptionButton


func _ready() -> void:
	if starts_with_focus:
		button.grab_focus()
	
	button.selected = SettingsManager.get_setting(section_name, key_name)
	button.connect("item_selected", self, "_on_OptionButton_item_selected")
	button.connect("item_focused", self, "_on_OptionButton_item_focused")
	update_value(button.selected)


func update_value(index: int) -> void:
	SettingsManager.set_setting(section_name, key_name, index)


func _on_OptionButton_item_selected(index: int) -> void:
	update_value(index)
	SettingsManager.play_sfx(0)


func _on_OptionButton_item_focused(_index: int) -> void:
	SettingsManager.play_sfx(1)
