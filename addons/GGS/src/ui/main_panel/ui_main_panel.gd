tool
extends Control

# SceneTree
onready var SettingsList: VBoxContainer = $"Tabs/Game Settings/MainArea/HBox/SettingsList"
onready var Inspector: VBoxContainer = $"Tabs/Game Settings/MainArea/HBox/Inspector"
onready var CreateBtn: Button = $"Tabs/Game Settings/Toolbar/Create"
onready var Search: HBoxContainer = $"Tabs/Game Settings/Toolbar/Search"

# Resources
onready var uiSettingItem: PackedScene = preload("../setting_item/uiSettingItem.tscn")


func _ready() -> void:
	reload_settings()


func _on_item_removed(index: int) -> void:
	# Erase the index and create the recovery list
	ggsManager.settings_data.erase(str(index))
	var recovery_list: Array = [[], [], [], []]
	for setting in ggsManager.settings_data.values():
		recovery_list[0].append(setting["name"])
		recovery_list[1].append(setting["default"])
		recovery_list[2].append(setting["current"])
		recovery_list[3].append(setting["logic"])
	
	# Rebuild the settings_data
	ggsManager.settings_data = {}
	for i in range(recovery_list[0].size()):
		ggsManager.settings_data[str(i)] = {
			"name": "",
			"default": {},
			"current": {},
			"logic": "",
		}
		ggsManager.settings_data[str(i)]["name"] = recovery_list[0][i]
		ggsManager.settings_data[str(i)]["default"] = recovery_list[1][i]
		ggsManager.settings_data[str(i)]["current"] = recovery_list[2][i]
		ggsManager.settings_data[str(i)]["logic"] = recovery_list[3][i]
	
	# Save and reload
	ggsManager.save_settings_data()
	reload_settings()


func reload_settings() -> void:
	# Reload json file
	ggsManager.load_settings_data()
	
	# Remake the tree with the new data
	var settings_list: Array = SettingsList.get_children()
	for item in settings_list:
		item.queue_free()
	
	for index in ggsManager.settings_data:
		var ui_item: HBoxContainer = uiSettingItem.instance()
		SettingsList.add_child(ui_item)
		ui_item.IndexField.text = "%02d"%[int(index)]
		ui_item.NameField.text = ggsManager.settings_data[index]["name"]

		var path: String = ggsManager.settings_data[index]["logic"]
		if path != "":
			ui_item.EditScriptBtn.hint_tooltip = "%s: %s"%[ui_item.EditScriptBtn.BASE_TOOLTIP ,path]
			ui_item.EditScriptBtn.disabled = false
			if not ResourceLoader.exists(path):
				ui_item.EditScriptBtn.broken = true
		
		ui_item.RemoveBtn.connect("item_removed", self, "_on_item_removed")
		
		# Retrigger the search if necessary
		Search.commence_search(Search.Field.text)
