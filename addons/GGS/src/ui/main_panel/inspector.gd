tool
extends VBoxContainer

var index: int = -1 setget set_index
onready var SettingsList: VBoxContainer = get_node("../SettingsList")


func clear(label_visible: bool = false) -> void:
	for child in get_children():
		if child.get_index() == 0:
			child.visible = label_visible
		else:
			child.queue_free()


# Highlight the currently selected setting
func set_index(value: int) -> void:
	index = value
	highlight_cur_index()


func highlight_cur_index() -> void:
	if index == -1:
		return
	yield(get_tree().create_timer(0.05), "timeout")
	var settings: Array = SettingsList.get_children()
	for setting in settings:
		if setting.get_index() == index:
			setting.modulate = ggsManager.COL_SELECTED
		else:
			setting.modulate = ggsManager.COL_GOOD
