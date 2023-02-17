@tool
extends Control

@onready var AddBtn: Button = %AddBtn
@onready var AIW: ConfirmationDialog = $AddItemWindow
@onready var List: Tree = %ItemList


func _ready() -> void:
	AddBtn.pressed.connect(_on_AddBtn_pressed)


### Adding Items

func _on_AddBtn_pressed() -> void:
	AIW.popup_centered()
