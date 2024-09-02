@tool
extends EditorPlugin

const SINGLETON_NAME: String = "GGS"
const SINGLETON_PATH: String = "res://addons/ggs/plugin/singleton/ggs.tscn"

var _InspectorPlugin: EditorInspectorPlugin = ggsInspectorPlugin.new()


func _enter_tree() -> void:
	_add_singleton()
	add_inspector_plugin(_InspectorPlugin)


func _exit_tree() -> void:
	remove_inspector_plugin(_InspectorPlugin)


func _add_singleton() -> void:
	if not ProjectSettings.has_setting("autoload/" + SINGLETON_NAME):
		add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)
