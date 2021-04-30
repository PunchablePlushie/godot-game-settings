tool
extends Button

const BASE_TOOLTIP: String = "Open Script"

onready var Root: HBoxContainer = get_node("../..")


func _ready() -> void:
	hint_tooltip = BASE_TOOLTIP


func _on_EditScript_pressed() -> void:
	var Editor: EditorPlugin = EditorPlugin.new()
	var path: String = ggsManager.settings_data[str(Root.get_index())]["logic"]
	if path != "":
		if ResourceLoader.exists(path):
			var resource = load(path)
			Editor.get_editor_interface().edit_resource(resource)
		else:
			printerr("GGS - %02d/Open_Script: Could not find the script at '%s'."%[Root.get_index(), path])
