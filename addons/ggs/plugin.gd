@tool
extends EditorPlugin

var main_panel_scn: PackedScene = preload("./editor/main_panel/main_panel.tscn")
var inspector_plugin: EditorInspectorPlugin = ggsInspectorPlugin.new()
var MainPanel: Control


func _enter_tree() -> void:
	_add_editor_interface_singleton()
	_add_plugin_singleton()
	_add_editor()
	add_inspector_plugin(inspector_plugin)


func _exit_tree() -> void:
	_remove_editor_interface_singleton()
	_remove_editor()
	remove_inspector_plugin(inspector_plugin)


### Singletons

func _add_editor_interface_singleton() -> void:
	if not Engine.has_singleton("ggsEI"):
		Engine.register_singleton("ggsEI", get_editor_interface())


func _remove_editor_interface_singleton() -> void:
	if Engine.has_singleton("ggsEI"):
		Engine.unregister_singleton("ggsEI")


func _add_plugin_singleton() -> void:
	if not ProjectSettings.has_setting("autoload/GGS"):
		add_autoload_singleton("GGS", "res://addons/ggs/classes/global/ggs.tscn")


### Main Editor

func _add_editor() -> void:
	MainPanel = main_panel_scn.instantiate()
	add_control_to_bottom_panel(MainPanel, "Game Settings")


func _remove_editor() -> void:
	if MainPanel:
		remove_control_from_bottom_panel(MainPanel)
		MainPanel.queue_free()
