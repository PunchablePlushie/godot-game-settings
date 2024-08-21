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


func _update_dark_panel() -> void:
	var editor_style: StyleBoxFlat = _EditorBase.get_theme_stylebox("panel", "PanelContainer")
	var stylebox: StyleBoxFlat = editor_style.duplicate()
	stylebox.draw_center = true
	stylebox.bg_color = _dark_color_2
	
	set_theme_item(DataType.DATA_TYPE_STYLEBOX, "panel", "DarkPanel", stylebox)


func _update_light_panel() -> void:
	var editor_style: StyleBoxFlat = _EditorBase.get_theme_stylebox("panel", "PanelContainer")
	var stylebox: StyleBoxFlat = editor_style.duplicate()
	stylebox.draw_center = true
	stylebox.bg_color = _base_color
	
	set_theme_item(DataType.DATA_TYPE_STYLEBOX, "panel", "LightPanel", stylebox)
