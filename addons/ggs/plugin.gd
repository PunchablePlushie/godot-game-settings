@tool
extends EditorPlugin

const SINGLETON_NAME: String = "GGS"
const SINGLETON_PATH: String = "res://addons/ggs/globals/ggs.tscn"
const BTM_PNL_NAME: String = "Game Settings"

var core_scn: PackedScene = preload("./editor/core/core.tscn")
var CoreNode: Control
var inspector_plugin: EditorInspectorPlugin = ggsInspectorPlugin.new()


func _enter_tree() -> void:
	_add_singleton()
	_add_editor()
	add_inspector_plugin(inspector_plugin)


func _exit_tree() -> void:
	_remove_editor()
	remove_inspector_plugin(inspector_plugin)


# Singleton #
func _add_singleton() -> void:
	if not ProjectSettings.has_setting("autoload/" + SINGLETON_NAME):
		add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)


# Core Scene #
func _add_editor() -> void:
	CoreNode = core_scn.instantiate()
	add_control_to_bottom_panel(CoreNode, BTM_PNL_NAME)


func _remove_editor() -> void:
	if CoreNode:
		remove_control_from_bottom_panel(CoreNode)
		CoreNode.queue_free()
