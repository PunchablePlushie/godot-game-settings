tool
extends Control

# SceneTree
onready var SettingsList: VBoxContainer = $Mrg/Scrl/VBox/Mrg/Scrl/SettingsList
onready var CreateBtn: Button = $Mrg/Scrl/VBox/HBox/Create
onready var ConfirmDialog: WindowDialog = $WinDialog

# Resources
onready var uiSettingItem: PackedScene = preload("../setting_item/uiSettingItem.tscn")


func _ready() -> void:
	_reload_settings()


func _on_Create_pressed() -> void:
	ConfirmDialog.popup_centered()


func _on_Reload_pressed() -> void:
	_reload_settings()


func _on_WinDialog_confirmed(setting_name, section, key) -> void:
	var new_setting: Dictionary = {
		"section": section,
		"key": key,
		"logic": "",
	}
	ggsManager.settings_data[setting_name] = new_setting
	ggsManager.save_as_json(ggsManager.settings_data, ggsManager.SETTINGS_DATA_PATH)
	
	_create_setting_item(setting_name)


func _create_setting_item(setting_name: String) -> void:
	var ui_item: HBoxContainer = uiSettingItem.instance()
	SettingsList.add_child(ui_item)
	ui_item.SettingName.text = setting_name
	ui_item.name = setting_name


func _reload_settings() -> void:
	# Check if the list is already up-to-date.
	var list_children: Array = SettingsList.get_children()
	var cur_settings: Array = []
	for setting in list_children:
		cur_settings.append(setting.name)
		
	var saved_settings: Array = []
	for setting in ggsManager.settings_data:
		saved_settings.append(setting)
		
	if cur_settings == saved_settings:
#		push_warning("GGS: Reload failed. The list is already up to date.")
		return
	
	# Reload settings
	if ggsManager.settings_data != {}:
		for item in list_children:
			item.queue_free()
		for setting in ggsManager.settings_data:
			_create_setting_item(setting)
