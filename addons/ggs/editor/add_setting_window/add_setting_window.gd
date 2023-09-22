@tool
extends ConfirmationDialog
signal template_selected(template: String, setting_name: String)

@onready var SettingList: ItemList = %SettingList
@onready var FilterField: LineEdit = %FilterField
@onready var RecentList: ItemList = %RecentList
@onready var ClearRecentBtn: Button = %ClearRecentBtn
@onready var NameField: LineEdit = %NameField
@onready var OkBtn: Button = get_ok_button()


func _ready() -> void:
	about_to_popup.connect(_on_about_to_popup)
	visibility_changed.connect(_on_visibility_changed)
	confirmed.connect(_on_confirmed)
	
	SettingList.item_selected.connect(_on_AnyList_item_selected.bind(SettingList))
	SettingList.item_activated.connect(_on_AnyList_item_activated.bind(SettingList))
	RecentList.item_selected.connect(_on_AnyList_item_selected.bind(RecentList))
	RecentList.item_activated.connect(_on_AnyList_item_activated.bind(RecentList))
	
	FilterField.text_changed.connect(_on_FilterField_text_changed)
	ClearRecentBtn.pressed.connect(_on_ClearRecentBtn_pressed)
	NameField.text_submitted.connect(_on_NameField_text_submitted)


func _confirm() -> void:
	var selected_item_index: int
	var selected_item_text: String
	
	if SettingList.is_anything_selected():
		selected_item_index = SettingList.get_selected_items()[0]
		selected_item_text = SettingList.get_item_text(selected_item_index)
	
	if RecentList.is_anything_selected():
		selected_item_index = RecentList.get_selected_items()[0]
		selected_item_text = RecentList.get_item_text(selected_item_index)
	
	template_selected.emit("%s.gd"%selected_item_text, NameField.text)
	ggsUtils.get_plugin_data().add_recent_setting(selected_item_text)


func _on_about_to_popup() -> void:
	OkBtn.disabled = true
	NameField.editable = true
	NameField.clear()
	FilterField.clear()
	_load_settings()
	_load_recent()


func _on_visibility_changed() -> void:
	if visible == true:
		FilterField.grab_focus()


func _on_confirmed() -> void:
	_confirm()


func _on_NameField_text_submitted(_submitted_text: String) -> void:
	_confirm()
	hide()


### Lists (General)

func _deselect_other_list(list: ItemList) -> void:
	if list == SettingList:
		RecentList.deselect_all()
	else:
		SettingList.deselect_all()


func _on_AnyList_item_selected(index: int, list: ItemList) -> void:
	OkBtn.disabled = true
	NameField.editable = false
	_deselect_other_list(list)


func _on_AnyList_item_activated(index: int, list: ItemList) -> void:
	OkBtn.disabled = false
	NameField.editable = true
	NameField.grab_focus()


### Setting List

func _load_settings() -> void:
	SettingList.clear()
	
	var dir: DirAccess = DirAccess.open(ggsUtils.get_plugin_data().dir_templates)
	var template_list: PackedStringArray = dir.get_files()
	for template in template_list:
		SettingList.add_item(template.get_basename())


func _filter_setting_list(filter: String) -> void:
	var to_remove: Array[int]
	_load_settings()
	
	for item_index in range(SettingList.item_count):
		var item_text: String = SettingList.get_item_text(item_index).to_lower()
		
		if not item_text.begins_with(filter.to_lower()):
			to_remove.push_front(item_index)
	
	for item_index in to_remove:
		SettingList.remove_item(item_index)
	
	SettingList.sort_items_by_text()


func _on_FilterField_text_changed(new_text: String) -> void:
	_filter_setting_list(new_text)
	NameField.editable = false


### Recent List

func _load_recent() -> void:
	RecentList.clear()
	
	var list: Array[String] = ggsUtils.get_plugin_data().recent_settings
	for item in list:
		RecentList.add_item(item)


func _on_ClearRecentBtn_pressed() -> void:
	ggsUtils.get_plugin_data().clear_recent_settings()
	RecentList.clear()
