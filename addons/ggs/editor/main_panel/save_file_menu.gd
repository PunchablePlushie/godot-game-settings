@tool
extends MenuButton

enum MenuItems {OPEN, REMAKE_CURRENT, REMAKE_DEFAULT}

var Menu: PopupMenu = get_popup()


func _ready() -> void:
	Menu.id_pressed.connect(_on_Menu_id_pressed)


func _open_save_file() -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var path: String = ProjectSettings.globalize_path(data.dir_save_file)
	var err: Error = OS.shell_open(path)
	if err != OK:
		printerr("GGS - Open Save File: An error has occured while opening the file. Code: %s"%[error_string(err)])


func _on_Menu_id_pressed(id: int) -> void:
	match id:
		MenuItems.OPEN:
			_open_save_file()
		MenuItems.REMAKE_CURRENT:
			GGS.request_update_save_file()
		MenuItems.REMAKE_DEFAULT:
			GGS.request_update_save_file_default()
