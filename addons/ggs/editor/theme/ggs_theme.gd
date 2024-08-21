@tool
extends Theme

const CORNER_RADIUS: String = "interface/theme/corner_radius"

var _editor_settings: EditorSettings
var _EditorBase: Control
var _base_color: Color
var _dark_color_2: Color


func update() -> void:
	_editor_settings = EditorInterface.get_editor_settings()
	_EditorBase = EditorInterface.get_base_control()
	_base_color = _EditorBase.get_theme_color("base_color", "Editor")
	_dark_color_2 = _EditorBase.get_theme_color("dark_color_2", "Editor")
	
	_update_base_panel()
	print("test")


func _update_base_panel() -> void:
	var corner_radius = _editor_settings.get_setting(CORNER_RADIUS)
	
	var stylebox: StyleBoxFlat = StyleBoxFlat.new()
	stylebox.bg_color = _dark_color_2
	stylebox.corner_detail = 3
	stylebox.set_corner_radius_all(corner_radius)
	stylebox.anti_aliasing = false
	stylebox.set_content_margin_all(5)
	
	set_theme_item(DataType.DATA_TYPE_STYLEBOX, "panel", "BasePanel", stylebox)
