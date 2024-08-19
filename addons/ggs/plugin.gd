@tool
extends EditorPlugin

const SINGLETON_NAME: String = "GGS"
const SINGLETON_PATH: String = "res://addons/ggs/globals/ggs.tscn"
const TOOL_ITEM: String = "About Godot Game Settings"
const ABOUT_SCN = preload("res://addons/ggs/scenes/about/about.tscn")

var inspector_plugin: EditorInspectorPlugin = ggsInspectorPlugin.new()


func _enter_tree() -> void:
	_add_singleton()
	add_tool_menu_item(TOOL_ITEM, _show_about)
	add_inspector_plugin(inspector_plugin)


func _exit_tree() -> void:
	remove_tool_menu_item(TOOL_ITEM)
	remove_inspector_plugin(inspector_plugin)


func _show_about() -> void:
	var About: AcceptDialog = ABOUT_SCN.instantiate()
	EditorInterface.popup_dialog_centered(About, About.min_size)


# Singleton #
func _add_singleton() -> void:
	if not ProjectSettings.has_setting("autoload/" + SINGLETON_NAME):
		add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)
