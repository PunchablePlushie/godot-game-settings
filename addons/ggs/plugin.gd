@tool
extends EditorPlugin

const ggs_globals_path: String = "res://addons/ggs/classes/ggs_globals.gd"

var main_panel_scn: PackedScene = preload("./editor/main_panel/main_panel.tscn")
var MainPanel: Control


func _enter_tree() -> void:
	_add_editor_interface_singleton()
	_add_plugin_singleton()
	_add_editor()


func _exit_tree() -> void:
	_remove_editor_interface_singleton()
	_remove_plugin_singleton()
	_remove_editor()


### Singletons

func _add_editor_interface_singleton() -> void:
	if not Engine.has_singleton("EI"):
		Engine.register_singleton("EI", get_editor_interface())


func _remove_editor_interface_singleton() -> void:
	if Engine.has_singleton("EI"):
		Engine.unregister_singleton("EI")


func _add_plugin_singleton() -> void:
	if not ProjectSettings.has_setting("autoload/GGS"):
		add_autoload_singleton("GGS", "res://addons/ggs/classes/ggs_globals.gd")


func _remove_plugin_singleton() -> void:
	if ProjectSettings.has_setting("autoload/GGS"):
		remove_autoload_singleton("GGS")


### Main Editor

func _add_editor() -> void:
	MainPanel = main_panel_scn.instantiate()
	add_control_to_bottom_panel(MainPanel, "Game Settings")


func _remove_editor() -> void:
	if MainPanel:
		remove_control_from_bottom_panel(MainPanel)
		MainPanel.queue_free()
