extends Control
signal confirmed()

@onready var ConfirmBtn: Button = %ConfirmBtn
@onready var FullscreenBtn: MarginContainer = %FullscreenBtn


func _ready() -> void:
	ConfirmBtn.pressed.connect(_on_ConfirmBtn_pressed)
	FullscreenBtn.Btn.grab_focus()


func _on_ConfirmBtn_pressed() -> void:
	confirmed.emit()
	queue_free()
