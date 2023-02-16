@tool
extends EditorPlugin

const ggs_globals_path: String = "res://addons/ggs/classes/ggs_globals.gd"

var main_panel_scn: PackedScene = preload("./editor/main_panel/main_panel.tscn")
var MainPanel: Control


func _enter_tree() -> void:
	if not ProjectSettings.has_setting("autoload/GGS"):
		add_autoload_singleton("GGS", "res://addons/ggs/classes/ggs_globals.gd")
	
	MainPanel = main_panel_scn.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(MainPanel)
	MainPanel.hide()



func _exit_tree() -> void:
	if ProjectSettings.has_setting("autoload/GGS"):
		remove_autoload_singleton("GGS")
	
	if MainPanel:
		MainPanel.queue_free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	MainPanel.visible = visible


func _get_plugin_name() -> String:
	return "Game Settings"


func _get_plugin_icon() -> Texture2D:
	return preload("./assets/main_screen_icon.svg")
