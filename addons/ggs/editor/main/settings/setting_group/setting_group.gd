@tool
extends PanelContainer
class_name ggsSettingGroup

var path: String

@onready var GroupName: CheckBox = $MainCtnr/GroupName
@onready var ItemCtnr: HFlowContainer = $MainCtnr/ItemCtnr


func add_item(item: Button) -> void:
	ItemCtnr.add_child(item)


func set_group_name(group_name: String) -> void:
	GroupName.text = group_name


func set_checked(checked: bool) -> void:
	GroupName.button_pressed = checked


func get_checked() -> bool:
	return GroupName.button_pressed
