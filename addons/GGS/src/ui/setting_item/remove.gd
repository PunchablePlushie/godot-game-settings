tool
extends Button
signal item_removed(index)

onready var ConfirmDialog: ConfirmationDialog = get_node("../../ConfirmDialog")
onready var Root: HBoxContainer = get_node("../..")


func _ready() -> void:
	hint_tooltip = "Remove Setting"


func _on_Remove_pressed() -> void:
	ConfirmDialog.popup_centered()


func _on_ConfirmDialog_confirmed() -> void:
	# Manage index highlight
	var inspector_index = Root.MainPanel.Inspector.index
	var root_index = Root.get_index()
	
	if root_index == inspector_index:
		Root.MainPanel.Inspector.index = -1
		Root.MainPanel.Inspector.clear(true)
	
	if root_index > inspector_index:
		Root.MainPanel.Inspector.highlight_cur_index()
	
	if root_index < inspector_index:
		Root.MainPanel.Inspector.index -= 1
	
	# Remove item
	emit_signal("item_removed", Root.get_index())
	Root.queue_free()

