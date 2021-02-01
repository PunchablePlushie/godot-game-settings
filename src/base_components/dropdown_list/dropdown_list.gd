class_name DropDownList
extends BaseComponent

onready var label: Label = $Label
onready var button: OptionButton = $OptionButton

func _ready() -> void:
	button.selected = SettingsManager.get_setting(section_name, key_name)
	label.text = setting_name


func update_value(index: int) -> void:
	SettingsManager.set_setting(section_name, key_name, index)


func _on_OptionButton_item_selected(index: int) -> void:
	update_value(index)
