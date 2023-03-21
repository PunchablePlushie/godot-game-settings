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
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var path: String = ProjectSettings.globalize_path(data.dir_save_file)
	var err: Error = OS.shell_open(path)
	if err != OK:
		printerr("GGS - Open Save File: An error has occured while opening the file. Code: %d"%err)


func _reset_save_file() -> void:
	ggsSaveFile.new().reset()


func _on_Menu_id_pressed(id: int) -> void:
	match id:
		MenuItems.OPEN:
			_open_save_file()
		MenuItems.RESET:
			_reset_save_file()
