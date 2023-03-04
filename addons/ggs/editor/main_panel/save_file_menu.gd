@tool
extends MenuButton

enum MenuItems {OPEN, RESET}

var Menu: PopupMenu = get_popup()


func _ready() -> void:
	Menu.id_pressed.connect(_on_Menu_id_pressed)
	
	_add_menu_items()


func _add_menu_items() -> void:
	Menu.clear()
	
	Menu.add_item("Open Save File", MenuItems.OPEN)
	Menu.add_separator()
	Menu.add_item("Reset to Default", MenuItems.RESET)


### Functionality

func _open_save_file() -> void:
	var path: String = ProjectSettings.globalize_path("user://settings.cfg")
	OS.shell_open(path)


func _reset_save_file() -> void:
	ggsSaveFile.new().reset()


func _on_Menu_id_pressed(id: int) -> void:
	match id:
		MenuItems.OPEN:
			_open_save_file()
		MenuItems.RESET:
			_reset_save_file()
