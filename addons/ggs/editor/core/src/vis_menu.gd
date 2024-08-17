@tool
extends MenuButton

var Menu: PopupMenu = get_popup()
var subCategries: ggsVisSubMenu = ggsVisSubMenu.new()


func _ready() -> void:
	_init_submenus()
	_init_items()


func _init_submenus() -> void:
	subCategries.pref_category = "categories"
	subCategries.pref_ids = ["addfield", "filterfield"]


func _init_items() -> void:
	Menu.clear()
	Menu.add_submenu_node_item("Categories", subCategries)
