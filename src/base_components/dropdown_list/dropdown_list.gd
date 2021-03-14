class_name DropDownList
extends BaseComponent

onready var setting: Node = GameSettings.find_node(setting_node)
onready var label: Label = $Label
onready var button: OptionButton = $OptionButton


func _ready() -> void:
	if starts_with_focus:
		button.grab_focus()
	
	button.selected = GameSettings.get_setting(setting.section, setting.key)
	button.connect("item_selected", self, "_on_OptionButton_item_selected")
	update_value(button.selected)


func update_value(index: int) -> void:
	GameSettings.set_setting(setting.section, setting.key, index)


func _on_OptionButton_item_selected(index: int) -> void:
	update_value(index)
