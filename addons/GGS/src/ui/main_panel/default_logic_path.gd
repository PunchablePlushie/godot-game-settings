tool
extends HBoxContainer

# Scene Tree
onready var OptionLabel: Label = $Label
onready var Field: LineEdit = $LineEdit
onready var OpenDirBtn: Button = $Button
onready var FileDial: FileDialog = get_node("../../../../FileDialog")


func _ready() -> void:
	Field.text = ggsManager.ggs_data["default_logic_path"]


func _on_Button_pressed() -> void:
	FileDial.current_path = Field.text+"/"
	FileDial.popup_centered()


func _on_FileDialog_dir_selected(dir) -> void:
	Field.text = dir
	ggsManager.ggs_data["default_logic_path"] = dir+"/"


func _on_LineEdit_text_entered(new_text: String) -> void:
	Field.release_focus()
	ggsManager.ggs_data["default_logic_path"] = new_text+"/"
