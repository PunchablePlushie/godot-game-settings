@tool
extends Theme

const TREE_EXPAND_MARGIN: int = 12

var editor_theme: Theme = ggsUtils.get_editor_interface().get_base_control().theme


func _init() -> void:
	_set_tree_theme()


### Tree
func _set_tree_theme() -> void:
	var default_selected: StyleBoxFlat = editor_theme.get_stylebox("selected", "Tree")
	var new_stylebox: StyleBoxFlat = default_selected.duplicate()
	new_stylebox.expand_margin_left = TREE_EXPAND_MARGIN
	
	set_stylebox("selected", "Tree", new_stylebox)
	set_stylebox("selected_focus", "Tree", new_stylebox)
