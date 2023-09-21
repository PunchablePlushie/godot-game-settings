@tool
extends Theme

const TREE_EXPAND_MARGIN: int = 6

var editor_theme: Theme


func update() -> void:
	editor_theme = ggsUtils.get_editor_interface().get_base_control().theme
	_set_tree()
	_set_big_tree()
	_set_window_bg()
	ResourceSaver.save(self, resource_path)


func _set_tree() -> void:
	var default: StyleBoxFlat = editor_theme.get_stylebox("selected", "Tree")
	
	var new_stylebox: StyleBoxFlat = default.duplicate()
	new_stylebox.expand_margin_left = TREE_EXPAND_MARGIN
	set_stylebox("selected", "Tree", new_stylebox)
	set_stylebox("selected_focus", "Tree", new_stylebox)


func _set_big_tree() -> void:
	var default: StyleBoxFlat = editor_theme.get_stylebox("selected", "Tree")
	
	var new_stylebox: StyleBoxFlat = default.duplicate()
	new_stylebox.expand_margin_left = TREE_EXPAND_MARGIN * 2
	set_stylebox("selected", "BigTree", new_stylebox)
	set_stylebox("selected_focus", "BigTree", new_stylebox)


func _set_window_bg() -> void:
	var default: StyleBoxFlat = editor_theme.get_stylebox("panel", "AcceptDialog")
	
	var new_stylebox: StyleBoxFlat = default.duplicate()
	set_stylebox("panel", "WindowBG", new_stylebox)
