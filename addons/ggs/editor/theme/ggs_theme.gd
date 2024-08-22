@tool
extends Theme

var _EditorBase: Control
var _base_color: Color
var _dark_color_2: Color


func update() -> void:
	_EditorBase = EditorInterface.get_base_control()
	_base_color = _EditorBase.get_theme_color("base_color", "Editor")
	_dark_color_2 = _EditorBase.get_theme_color("dark_color_2", "Editor")
	
	_update_dark_panel()
	_update_light_panel()
	_update_item_list()


func _update_dark_panel() -> void:
	var stylebox: StyleBoxFlat = _EditorBase.get_theme_stylebox("panel", "PanelContainer").duplicate()
	stylebox.draw_center = true
	stylebox.bg_color = _dark_color_2
	
	set_theme_item(DataType.DATA_TYPE_STYLEBOX, "panel", "DarkPanel", stylebox)


func _update_light_panel() -> void:
	var stylebox: StyleBoxFlat = _EditorBase.get_theme_stylebox("panel", "PanelContainer").duplicate()
	stylebox.draw_center = true
	stylebox.bg_color = _base_color
	
	set_theme_item(DataType.DATA_TYPE_STYLEBOX, "panel", "LightPanel", stylebox)


func _update_item_list() -> void:
	var tree_style: StyleBoxFlat = _EditorBase.get_theme_stylebox("panel", "Tree")
	
	var panel_style: StyleBoxFlat = _EditorBase.get_theme_stylebox("panel", "ItemList").duplicate()
	panel_style.bg_color = tree_style.bg_color
	
	var focus_style: StyleBoxFlat = _EditorBase.get_theme_stylebox("focus", "ItemList").duplicate()
	focus_style.bg_color = tree_style.bg_color
	
	set_theme_item(DataType.DATA_TYPE_STYLEBOX, "panel", "ItemList", panel_style)
	set_theme_item(DataType.DATA_TYPE_STYLEBOX, "focus", "ItemList", focus_style)
