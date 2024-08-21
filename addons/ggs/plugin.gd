@tool
extends EditorPlugin

const SINGLETON_NAME: String = "GGS"
const SINGLETON_PATH: String = "res://addons/ggs/globals/ggs.tscn"
const EDITOR_NAME: String = "Game Settings"
const EDITOR_SCN = preload("res://addons/ggs/editor/core/core.tscn")
const THEME: Theme = preload("res://addons/ggs/editor/theme/ggs_theme.tres")

var _InspectorPlugin: EditorInspectorPlugin = ggsInspectorPlugin.new()
var _Editor: MarginContainer


func _enter_tree() -> void:
	_set_editor_enabled(true)
	_add_singleton()
	add_inspector_plugin(_InspectorPlugin)
	THEME.update()


func _exit_tree() -> void:
	_set_editor_enabled(false)
	remove_inspector_plugin(_InspectorPlugin)


func _set_editor_enabled(enabled: bool) -> void:
	match enabled:
		true:
			_Editor = EDITOR_SCN.instantiate()
			add_control_to_bottom_panel(_Editor, EDITOR_NAME)
		false:
			if _Editor:
				remove_control_from_bottom_panel(_Editor)


func _add_singleton() -> void:
	if not ProjectSettings.has_setting("autoload/" + SINGLETON_NAME):
		add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)
