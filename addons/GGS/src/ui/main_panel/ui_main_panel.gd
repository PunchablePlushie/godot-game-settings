tool
extends Control

# SceneTree
onready var SettingsList: VBoxContainer = $Mrg/Scrl/VBox/Mrg/Scrl/SettingsList
onready var CreateBtn: Button = $Mrg/Scrl/VBox/HBox/Create
onready var ConfirmDialog: WindowDialog = $WinDialog

# Resources
onready var uiSettingItem: PackedScene = preload("../setting_item/uiSettingItem.tscn")
onready var Setting: Script = preload("../../classes/setting.gd")


func _on_Create_pressed():
	ConfirmDialog.popup_centered()


func _on_WinDialog_confirmed(setting_name, section, key):
	_create_new_setting(setting_name, section, key)


func _create_new_setting(setting_name: String, section: String, key: String) -> void:
	var ui_item: HBoxContainer = uiSettingItem.instance()
	SettingsList.add_child(ui_item)
	ui_item.SettingName.text = setting_name
	
	var new_setting: Object = Setting.new()
	new_setting.properties["name"] = setting_name
	new_setting.properties["section"] = section
	new_setting.properties["key"] = key
	_save_setting_data(new_setting)


func _save_setting_data(setting: Object) -> void:
	var data: String = JSON.print(setting.properties)
	var file: File = File.new()
	var err: int = file.open("res://test_data.json", File.WRITE)
	if err == OK:
		file.store_string(data)
		file.close()


func _load_setting_data() -> Dictionary:
	var data: String = ""
	var file: File = File.new()
	var err: int = file.open("res://test_data.json", File.READ)
	if err == OK:
		data = file.get_as_text()
		file.close()
	var result: JSONParseResult = JSON.parse(data)
	
	return result.result



