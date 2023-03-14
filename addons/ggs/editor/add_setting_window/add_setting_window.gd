@tool
extends ConfirmationDialog
signal setting_selected(setting: ggsSetting)

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
	confirmed.connect(_on_confirmed)
	
	SettingList.item_selected.connect(_on_AnyList_item_selected.bind(SettingList))
	SettingList.item_activated.connect(_on_AnyList_item_activated.bind(SettingList))
	RecentList.item_selected.connect(_on_AnyList_item_selected.bind(RecentList))
	RecentList.item_activated.connect(_on_AnyList_item_activated.bind(RecentList))
	
	FilterField.text_changed.connect(_on_FilterField_text_changed)


func _confirm() -> void:
	var selected_setting: ggsSetting
	var selected_item: int
	
	if SettingList.is_anything_selected():
		selected_item = SettingList.get_selected_items()[0]
		selected_setting = SettingList.get_item_metadata(selected_item)
	
	if RecentList.is_anything_selected():
		selected_item = RecentList.get_selected_items()[0]
		selected_setting = RecentList.get_item_metadata(selected_item)
	
	if selected_setting == null:
		return
	
	setting_selected.emit(selected_setting)
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	data.add_recent_setting(selected_setting)


func _on_about_to_popup() -> void:
	OkBtn.disabled = true
	DescField.clear_content()
	FilterField.clear()
	_populate_list(SettingList)
	_populate_list(RecentList)


func _on_visibility_changed() -> void:
	if visible == true:
		FilterField.grab_focus()


func _on_confirmed() -> void:
	_confirm()


### List/General

func _populate_list(list: ItemList) -> void:
	list.clear()
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var base_path: String = data.dir_settings
	
	var setting_files: PackedStringArray
	if list == SettingList:
		setting_files = DirAccess.get_files_at(base_path)
	else:
		setting_files= PackedStringArray(data.recent_settings)
	
	for setting_file in setting_files:
		var path: String = base_path.path_join(setting_file)
		if not FileAccess.file_exists(path):
			data.recent_settings.erase(setting_file)
			data.save()
			continue
		
		var script: Script = load(path)
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
	OkBtn.disabled = false
	DescField.set_content(list.get_item_metadata(index))
	_deselect_other_list(list)


func _on_AnyList_item_activated(index: int, list: ItemList) -> void:
	_confirm()
	hide()


### SettingList/Filtering

func _filter_setting_list(filter: String) -> void:
	var to_remove: Array[int]
	_populate_list(SettingList)
	
	for item_index in range(SettingList.item_count):
		var item_text: String = SettingList.get_item_text(item_index).to_lower()
		
		if not item_text.begins_with(filter.to_lower()):
			to_remove.push_front(item_index)
	
	for item_index in to_remove:
		SettingList.remove_item(item_index)
	
	SettingList.sort_items_by_text()


func _on_FilterField_text_changed(new_text: String) -> void:
	_filter_setting_list(new_text)
