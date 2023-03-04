@tool
extends Window

@onready var OkBtn: Button = %OkBtn

func _ready() -> void:
	close_requested.connect(_on_close_requested)
	OkBtn.pressed.connect(_on_OkBtn_pressed)
	
	hide()


func _on_close_requested() -> void:
	hide()


func _on_OkBtn_pressed() -> void:
	hide()
