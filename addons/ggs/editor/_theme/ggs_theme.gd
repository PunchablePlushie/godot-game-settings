@tool
extends Theme

const TREE_EXPAND_MARGIN: int = 6

var editor_theme: Theme



func _notification(what: int) -> void: #?1
	if what == NOTIFICATION_POSTINITIALIZE:
		editor_theme = ggsUtils.get_editor_interface().get_base_control().theme
		_set_tree()
		_set_window_bg()


func _set_tree() -> void:
	var default: StyleBoxFlat = editor_theme.get_stylebox("selected", "Tree")
	
	var new_stylebox: StyleBoxFlat = default.duplicate()
	new_stylebox.expand_margin_left = TREE_EXPAND_MARGIN
	set_stylebox("selected", "Tree", new_stylebox)
	set_stylebox("selected_focus", "Tree", new_stylebox)


func _set_window_bg() -> void:
	var default: StyleBoxFlat = editor_theme.get_stylebox("panel", "AcceptDialog")
	
	var new_stylebox: StyleBoxFlat = default.duplicate()
	set_stylebox("panel", "WindowBG", new_stylebox)


### Comments

#1: PostInit is used instead of Init to create a small delay so these stuff happen
# after the editor interface singleton is registered in the engine (check plugin.gd).
# Prevents unnecessary error messages at the start of the project.
