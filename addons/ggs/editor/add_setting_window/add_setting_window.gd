@tool
extends ConfirmationDialog

var selected_setting: ggsSetting: set = _set_selected_setting

@onready var SettingList: ItemList = %SettingList
@onready var RecentList: ItemList = %RecentList
@onready var DescField: RichTextLabel = %DescField
@onready var FilterField: LineEdit = %FilterField
@onready var OkBtn: Button = get_ok_button()


func _init() -> void:
	hide()


func _ready() -> void:
	about_to_popup.connect(_on_about_to_popup)
	visibility_changed.connect(_on_visibility_changed)
	
	SettingList.item_selected.connect(_on_AnyList_item_selected.bind(SettingList))
	SettingList.item_activated.connect(_on_AnyList_item_activated.bind(SettingList))
	RecentList.item_selected.connect(_on_AnyList_item_selected.bind(RecentList))
	RecentList.item_activated.connect(_on_AnyList_item_activated.bind(RecentList))
	
	FilterField.text_changed.connect(_on_FilterField_text_changed)


func _set_selected_setting(value: ggsSetting) -> void:
	selected_setting = value
	
	if selected_setting == null:
		OkBtn.disabled = true
		DescField.clear_content()
	else:
		OkBtn.disabled = false
		DescField.set_content(selected_setting)


func _on_about_to_popup() -> void:
	selected_setting = null
	FilterField.clear()
	_populate_list(SettingList)
	_populate_list(RecentList)


func _on_visibility_changed() -> void:
	if visible == true:
		FilterField.grab_focus()


### List/General

func _populate_list(list: ItemList) -> void:
	list.clear()
	
	var base_path: String = GGS.data.dir_settings
	
	var setting_files: PackedStringArray
	if list == SettingList:
		setting_files = DirAccess.get_files_at(base_path)
	else:
		setting_files= PackedStringArray(GGS.data.recent_settings)
	
	for setting_file in setting_files:
		var script: Script = load(base_path.path_join(setting_file))
		var setting: ggsSetting = script.new()
		
		var text: String = setting.name
		var icon: Texture2D = setting.icon
		
		var item_index: int = list.add_item(text, icon)
		list.set_item_metadata(item_index, setting)


func _deselect_other_list(list: ItemList) -> void:
	if list == SettingList:
		RecentList.deselect_all()
	else:
		SettingList.deselect_all()


func _on_AnyList_item_selected(index: int, list: ItemList) -> void:
	selected_setting = list.get_item_metadata(index)
	_deselect_other_list(list)


func _on_AnyList_item_activated(_index: int, list: ItemList) -> void:
	confirmed.emit()
	hide()
	
	if list == SettingList:
		GGS.data.add_recent_setting(selected_setting)


### SettingList/Filtering

func _filter_setting_list(filter: String) -> void:
	_populate_list(SettingList)
	selected_setting = null
	
	for item_index in range(SettingList.item_count):
		var item_text: String = SettingList.get_item_text(item_index).to_lower()
		
		if not item_text.begins_with(filter.to_lower()):
			SettingList.remove_item(item_index)
	
	SettingList.sort_items_by_text()


func _on_FilterField_text_changed(new_text: String) -> void:
	_filter_setting_list(new_text)
