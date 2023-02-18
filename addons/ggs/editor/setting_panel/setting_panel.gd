@tool
extends Control

@onready var AddBtn: Button = %AddBtn
@onready var ASW: ConfirmationDialog = $AddSettingWindow
@onready var List: Tree = %SettingList


func _ready() -> void:
	AddBtn.pressed.connect(_on_AddBtn_pressed)


### Adding Settings

func _on_AddBtn_pressed() -> void:
	ASW.popup_centered()
