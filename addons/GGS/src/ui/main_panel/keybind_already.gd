tool
extends HBoxContainer

var saved: bool = true setget set_saved

# Scene Tree
onready var OptionLabel: Label = $Label
onready var Field: LineEdit = $LineEdit


func _ready() -> void:
	Field.text = ggsManager.ggs_data["keybind_assigned_text"]
	Field.hint_tooltip = ""
	OptionLabel.hint_tooltip = "Popup message when using ggsKeybind components. Shown when the input is already assigned to another action."


func _on_LineEdit_text_entered(new_text: String) -> void:
	Field.release_focus()
	
	ggsManager.ggs_data["keybind_assigned_text"] = new_text
	ggsManager.save_ggs_data()
	
	self.saved = true


func _on_LineEdit_text_changed(new_text: String) -> void:
	self.saved = false


func set_saved(value: bool) -> void:
	saved = value
	if saved:
		modulate = ggsManager.COL_GOOD
	else:
		modulate = ggsManager.COL_ERR
