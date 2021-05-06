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
	# Clear the key list if it's showing the keys of the item that'll be removed
	var inspector_index = Root.MainPanel.Inspector.index
	if inspector_index == Root.get_index():
		Root.MainPanel.Inspector.clear(true)
	
	# Remove item
	emit_signal("item_removed", Root.get_index())
	Root.queue_free()

