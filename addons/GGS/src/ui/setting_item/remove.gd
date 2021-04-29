tool
extends Button
signal item_removed

onready var ConfirmDialog: ConfirmationDialog = get_node("../../ConfirmDialog")
onready var Root: HBoxContainer = get_node("../..")

func _ready() -> void:
	hint_tooltip = "Remove Setting"


func _on_Remove_pressed() -> void:
	ConfirmDialog.popup_centered()


func _on_ConfirmDialog_confirmed() -> void:
	emit_signal("item_removed")
	Root.queue_free()

