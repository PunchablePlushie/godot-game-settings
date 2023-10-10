@tool
extends Theme

const SETTING_LIST_MARGIN: int = 10

var editor_theme: Theme


func update() -> void:
	editor_theme = ggsUtils.get_editor_interface().get_base_control().theme
	_set_window_bg()
	_set_setting_list_bg()
	_set_setting_item_bg()
	ResourceSaver.save(self, resource_path)


func _set_setting_list_bg() -> void:
	var default: StyleBoxFlat = editor_theme.get_stylebox("panel", "ItemList")
	
	var new_stylebox: StyleBoxFlat = default.duplicate()
	new_stylebox.set_content_margin_all(SETTING_LIST_MARGIN)
	set_stylebox("panel", "SettingListBG", new_stylebox)


func _set_setting_item_bg() -> void:
	var default: StyleBoxFlat = editor_theme.get_stylebox("panel", "AcceptDialog")
	
	var new_stylebox: StyleBoxFlat = default.duplicate()
	new_stylebox.set_content_margin_all(SETTING_LIST_MARGIN)
	new_stylebox.set_corner_radius_all(3)
	set_stylebox("panel", "SettingItemBG", new_stylebox)


func _set_window_bg() -> void:
	var default: StyleBoxFlat = editor_theme.get_stylebox("panel", "AcceptDialog")
	
	var new_stylebox: StyleBoxFlat = default.duplicate()
	set_stylebox("panel", "PrefWindowBG", new_stylebox)
