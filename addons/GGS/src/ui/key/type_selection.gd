tool
extends OptionButton

onready var ValueField: LineEdit = get_node("../Value")


func _ready() -> void:
	text = ""

func _on_TypeSelection_item_selected(index: int) -> void:
	text = ""
	ValueField.convert_value(ValueField.text)
