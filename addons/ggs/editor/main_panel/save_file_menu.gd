@tool
extends MenuButton

enum MenuItems {OPEN, REMAKE_DEFAULT, REMAKE_CURRENT}

var Menu: PopupMenu = get_popup()


func _ready() -> void:
	Menu.id_pressed.connect(_on_Menu_id_pressed)
	
	_add_menu_items()


func _add_menu_items() -> void:
	Menu.clear()
	
	Menu.add_item("Open Save File", MenuItems.OPEN)
	Menu.add_separator()
	Menu.add_item("Remake from Defaults", MenuItems.REMAKE_DEFAULT)
	Menu.add_item("Remake from Currents", MenuItems.REMAKE_CURRENT)


### Functionality

func _open_save_file() -> void:
	var path: String = ProjectSettings.globalize_path("user://settings.cfg")
	OS.shell_open(path)


func _on_Menu_id_pressed(id: int) -> void:
	match id:
		MenuItems.OPEN:
			_open_save_file()
		MenuItems.REMAKE_DEFAULT:
			pass
		MenuItems.REMAKE_CURRENT:
			pass
