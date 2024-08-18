@tool
extends LineEdit

@export_group("Nodes")
@export var List: ggsBaseItemList


func _ready() -> void:
	text_changed.connect(_on_text_changed)
	List.loaded.connect(_on_List_loaded)
	GGS.Event.category_selected.connect(_on_Global_category_selected)


func _on_text_changed(new_text: String) -> void:
	List.filter_list(new_text)


func _on_List_loaded() -> void:
	clear()


func _on_Global_category_selected(category: String) -> void:
	if category.is_empty():
		clear()
		release_focus()
