@tool
extends ggsBasePanelField


func _ready() -> void:
	text_changed.connect(_on_text_changed)


func _on_text_changed(new_text: String) -> void:
	List.filter_list(new_text)
