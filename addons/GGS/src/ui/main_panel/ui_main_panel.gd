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
			"section": "",
			"key": "",
			"logic": "",
		}
		ggsManager.settings_data[index]["name"] = item.NameField.text
		ggsManager.settings_data[index]["section"] = item.SectionField.text
		ggsManager.settings_data[index]["key"] = item.KeyField.text
		ggsManager.settings_data[index]["logic"] = item.EditScriptBtn.text
	
	ggsManager.save_as_json(ggsManager.settings_data, ggsManager.SETTINGS_DATA_PATH)


func reload_settings() -> void:
	# Check if the list is already up-to-date.
	var list_children: Array = SettingsList.get_children()
	var cur_settings: Array = []
	for setting in list_children:
		cur_settings.append(str(setting.get_index()))
		
	var saved_settings: Array = []
	for setting in ggsManager.settings_data:
		saved_settings.append(setting)
		
	if cur_settings == saved_settings:
		#push_warning("GGS: Reload failed. The list is already up to date.")
		return
	
	# Reload settings
	if ggsManager.settings_data != {}:
		for item in list_children:
			item.queue_free()
		for index in ggsManager.settings_data:
				var ui_item: HBoxContainer = uiSettingItem.instance()
				SettingsList.add_child(ui_item)
				ui_item.NameField.text = ggsManager.settings_data[index]["name"]
				
				ui_item.SectionField.text = ggsManager.settings_data[index]["section"]
				ui_item.SectionField.editable = true
				
				ui_item.KeyField.text = ggsManager.settings_data[index]["key"]
				ui_item.KeyField.editable = true
				
				var path: String = ggsManager.settings_data[index]["logic"]
				ui_item.EditScriptBtn.hint_tooltip = "Open Script: %s"%[path]
				ui_item.EditScriptBtn.disabled = false
				ui_item.AddScriptBtn.disabled = false
				
				ui_item.initialized = true
				ui_item.get_node("HBox/Remove").connect("item_removed", self, "_on_item_removed")
