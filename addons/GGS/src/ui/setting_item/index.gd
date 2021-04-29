tool
extends LineEdit


func _ready() -> void:
	text = "%02d"%[get_parent().get_index()]
	hint_tooltip = "Index"
