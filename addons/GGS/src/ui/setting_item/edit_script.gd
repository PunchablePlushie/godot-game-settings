tool
extends Button

const BASE_TOOLTIP: String = "Open Script"

var broken: bool = false setget set_broken
onready var Root: HBoxContainer = get_node("../..")
onready var AddScriptBtn: Button = get_node("../AddScript")
onready var Menu: PopupMenu = $PopupMenu


func _ready() -> void:
	hint_tooltip = BASE_TOOLTIP


func _on_EditScript_pressed() -> void:
	var Editor: EditorPlugin = EditorPlugin.new()
	var path: String = ggsManager.settings_data[str(Root.get_index())]["logic"]
	if path != "":
		if ResourceLoader.exists(path):
			var resource = load(path)
			Editor.get_editor_interface().edit_resource(resource)
		else:
			ggsManager.print_err("%02d/Open_Script"%[Root.get_index()], "Could not find the script at '%s'."%[path])
			self.broken = true


func set_broken(value: bool) -> void:
	broken = value
	if not broken:
		modulate = ggsManager.COL_GOOD
	else:
		modulate = ggsManager.COL_ERR


# Context Menu
func _on_EditScript_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			_create_popup_menu()


func _create_popup_menu() -> void:
	Menu.clear()
	
	Menu.add_item("Copy Path")
	Menu.add_item("Paste Path")
	
	if disabled:
		Menu.set_item_disabled(0, true)
		Menu.set_item_tooltip(0, "No path is available to copy")
	if ggsManager.script_clipboard == "":
		Menu.set_item_disabled(1, true)
		Menu.set_item_tooltip(1, "No path is copied to GGS clipboard")
	
	Menu.rect_global_position = get_global_mouse_position()
	Menu.popup()


func _on_PopupMenu_index_pressed(index: int) -> void:
	match index:
		0:
			var path: String = hint_tooltip.trim_prefix("%s: "%[BASE_TOOLTIP])
			ggsManager.script_clipboard = path
			ggsManager.print_notif("%02d"%[Root.get_index()], "Script path copied to GGS clipboard (%s)"%[path])
		1:
			AddScriptBtn.assign_script(ggsManager.script_clipboard)
	
