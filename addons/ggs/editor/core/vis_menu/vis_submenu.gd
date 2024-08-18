@tool
extends PopupMenu

var section: String


func _ready() -> void:
	index_pressed.connect(_on_index_pressed)
	hide_on_checkable_item_selection = false
	
	_init_items()
	_init_item_states()


func _init_items() -> void:
	var elements: Dictionary = GGS.Pref.data.ui_vis[section]
	for element in elements:
		add_check_item(element.capitalize())


func _init_item_states() -> void:
	var idx: int = 0
	var elements: Dictionary = GGS.Pref.data.ui_vis[section]
	for checked in elements.values():
		set_item_checked(idx, checked)
		
		idx += 1


func _on_index_pressed(idx: int) -> void:
	var elements: Dictionary = GGS.Pref.data.ui_vis[section]
	var element_name: String = elements.keys()[idx]
	var checked: bool = elements[element_name]
	
	set_item_checked(idx, !checked)
	GGS.Pref.data.ui_vis[section][element_name] = !checked
	GGS.Event.ui_vis_changed.emit(section, element_name, !checked)
