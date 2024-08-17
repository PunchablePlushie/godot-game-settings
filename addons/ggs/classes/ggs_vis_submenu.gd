@tool
extends PopupMenu
class_name ggsVisSubMenu
## Handles submenu features of the Visibility Menu in the GGS editor.

var pref_prefix
var pref_category: String
var pref_ids: PackedStringArray


func _ready() -> void:
	index_pressed.connect(_on_index_pressed)
	pref_prefix = "SHOW_UI_%s"%pref_category
	hide_on_checkable_item_selection = false
	
	_init_items()
	_init_item_states()


func _init_items() -> void:
	for id in pref_ids:
		add_check_item(id.capitalize())


func _init_item_states() -> void:
	var pref: ggsPluginPref = ggsPluginPref.new()
	var idx: int = 0
	for id in pref_ids:
		var checked: bool = pref.get_config("%s_%s"%[pref_prefix, id])
		set_item_checked(idx, checked)
		
		idx += 1


func _on_index_pressed(idx: int) -> void:
	var pref: ggsPluginPref = ggsPluginPref.new()
	var pref_id: String = pref_ids[idx]
	var config: String = "%s_%s"%[pref_prefix, pref_id]
	var checked: bool = pref.get_config(config)
	
	set_item_checked(idx, !checked)
	pref.set_config(config, !checked)
	GGS.Event.ui_vis_changed.emit(pref_category, pref_id, !checked)
