@tool
extends MenuButton

const submenu_script: Script = preload("./vis_submenu.gd")

var Menu: PopupMenu = get_popup()


func _ready() -> void:
	_init_items()


func _init_items() -> void:
	Menu.clear()
	
	var sections: Dictionary = GGS.Pref.data.ui_vis
	for section in sections:
		var Submenu: PopupMenu = submenu_script.new()
		Submenu.section = section
		
		Menu.add_submenu_node_item(section.capitalize(), Submenu)
