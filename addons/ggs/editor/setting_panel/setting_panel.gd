@tool
extends Control

@onready var AddBtn: Button = %AddBtn
@onready var ASW: ConfirmationDialog = $AddSettingWindow
@onready var List: Tree = %SettingList


func _ready() -> void:
	AddBtn.pressed.connect(_on_AddBtn_pressed)
	ASW.confirmed.connect(_on_ASW_confirmed.bind(ASW.selected_setting))


### Adding Settings

func _on_AddBtn_pressed() -> void:
	ASW.popup_centered()


func _on_ASW_confirmed(selected_setting: ggsSetting) -> void:
	prints(selected_setting)
