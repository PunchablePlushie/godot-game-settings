@tool
extends LineEdit
class_name ggsBasePanelField

enum Mode {NONE, CATEGORY, GROUP, SETTING}

@export var mode: Mode = Mode.NONE

@export_group("Nodes")
@export var List: ggsBaseItemList


func _ready() -> void:
	if List:
		List.loaded.connect(_on_List_loaded)
	
	match mode:
		Mode.GROUP:
			GGS.Event.category_selected.connect(_on_category_selected)
		Mode.SETTING:
			GGS.Event.group_selected.connect(_on_group_selected)


func _set_disabled(disabled: bool) -> void:
	editable = !disabled
	if disabled:
		clear()
		release_focus()


func _on_category_selected(category: String) -> void:
	if mode != Mode.GROUP:
		return
	
	_set_disabled(category.is_empty())


func _on_group_selected(group: String) -> void:
	if mode != Mode.SETTING:
		return
	
	_set_disabled(group.is_empty())


func _on_List_loaded() -> void:
	clear()
