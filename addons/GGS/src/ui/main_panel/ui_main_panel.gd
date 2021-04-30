tool
extends Control

# SceneTree
onready var SettingsList: VBoxContainer = $Mrg/Scrl/VBox/Mrg/Scrl/SettingsList
onready var CreateBtn: Button = $Mrg/Scrl/VBox/HBox/Create

# Resources
onready var uiSettingItem: PackedScene = preload("../setting_item/uiSettingItem.tscn")


func _ready() -> void:
	reload_settings()


func _on_item_removed() -> void:
	# Creates a small delay to fix a bug
	yield(get_tree().create_timer(0.2), "timeout")
	
	# Rebuild the settings_data
	ggsManager.settings_data = {}
	for item in SettingsList.get_children():
		var index: String = str(item.get_index())
		ggsManager.settings_data[index] = {
			"name": "",
			"value_type": 0,
			"default": null,
			"default_raw": "",
			"current": null,
			"logic": "",
		}
		ggsManager.settings_data[index]["name"] = item.NameField.text
		ggsManager.settings_data[index]["logic"] = item.EditScriptBtn.text
	
	ggsManager.save_settings_data()


func reload_settings() -> void:
	# Check if the list is already up-to-date.
	var settings_list: Array = SettingsList.get_children()
	var cur_settings: Array = []
	for item in settings_list:
		cur_settings.append(str(item.get_index()))
		
	var saved_settings: Array = []
	for setting in ggsManager.settings_data:
		saved_settings.append(setting)
		
	if cur_settings == saved_settings:
		#push_warning("GGS - Reload List: Reload failed. The list is already up to date.")
		return
	
	# Reload settings
	if ggsManager.settings_data != {}:
		for item in settings_list:
			item.queue_free()
		for index in ggsManager.settings_data:
			var ui_item: HBoxContainer = uiSettingItem.instance()
			SettingsList.add_child(ui_item)
			ui_item.NameField.text = ggsManager.settings_data[index]["name"]
			ui_item.DefaultType.selected = ggsManager.settings_data[index]["value_type"]
			ui_item.DefaultField.text = ggsManager.settings_data[index]["default_raw"]
			
			var path: String = ggsManager.settings_data[index]["logic"]
			if path != "":
				ui_item.EditScriptBtn.hint_tooltip = "%s: %s"%[ui_item.EditScriptBtn.BASE_TOOLTIP ,path]
				ui_item.EditScriptBtn.disabled = false
			
			ui_item.initialized = true
			ui_item.RemoveBtn.connect("item_removed", self, "_on_item_removed")
