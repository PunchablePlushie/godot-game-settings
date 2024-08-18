@tool
extends MarginContainer

@export_multiline var label_text: String

@onready var Text: Label = $Text


func _ready() -> void:
	GGS.Event.category_selected.connect(_on_Global_category_selected)
	
	Text.text = label_text
	visible = true


func _on_Global_category_selected(category: String) -> void:
	visible = category.is_empty()
