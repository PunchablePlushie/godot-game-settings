@tool
extends ggsBasePanelField


func _ready() -> void:
	super()
	text_changed.connect(_on_text_changed)
	GGS.Event.category_selected.connect(_on_Global_category_selected)


func _on_text_changed(new_text: String) -> void:
	List.filter_list(new_text)


func _on_Global_category_selected(category: String) -> void:
	set_disabled(category.is_empty())
