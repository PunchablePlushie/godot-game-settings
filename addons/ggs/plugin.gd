@tool
extends EditorPlugin

const ggs_globals_path: String = "res://addons/ggs/classes/ggs_globals.gd"

var main_panel_scn: PackedScene = preload("./editor/main_panel/main_panel.tscn")
var MainPanel: Control


func _enter_tree() -> void:
	_add_editor_interface_singleton()
	_add_plugin_singleton()
	_add_editor()
	_create_save_file()


func _exit_tree() -> void:
	_remove_editor_interface_singleton()
	_remove_editor()


func _create_save_file():
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	if FileAccess.file_exists(data.dir_save_file):
		return
	
	var save_file: ggsSaveFile = ggsSaveFile.new()
	save_file.save(data.dir_save_file)


### Singletons

func _add_editor_interface_singleton() -> void:
	if not Engine.has_singleton("ggsEI"):
		Engine.register_singleton("ggsEI", get_editor_interface())


func _remove_editor_interface_singleton() -> void:
	if Engine.has_singleton("ggsEI"):
		Engine.unregister_singleton("ggsEI")


func _add_plugin_singleton() -> void:
	if not ProjectSettings.has_setting("autoload/GGS"):
		add_autoload_singleton("GGS", "res://addons/ggs/classes/ggs_globals.gd")


### Main Editor

func _add_editor() -> void:
	MainPanel = main_panel_scn.instantiate()
	add_control_to_bottom_panel(MainPanel, "Game Settings")


func _remove_editor() -> void:
	if MainPanel:
		remove_control_from_bottom_panel(MainPanel)
		MainPanel.queue_free()
