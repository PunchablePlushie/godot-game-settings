@tool
extends ConfirmationDialog

@onready var GroupList: ItemList = %GroupList
@onready var SettingList: ItemList = %SettingList
@onready var DescField: RichTextLabel = %DescField
@onready var FilterField: LineEdit = %FilterField
@onready var MCBtn: Button = %MatchCaseBtn
@onready var OkBtn: Button = get_ok_button()


func _init() -> void:
	hide()


func _ready() -> void:
	about_to_popup.connect(_on_about_to_popup)
	visibility_changed.connect(_on_visibility_changed)
	
	GroupList.item_selected.connect(_on_AnyList_item_selected.bind(GroupList))
	SettingList.item_selected.connect(_on_AnyList_item_selected.bind(SettingList))
	GroupList.item_activated.connect(_on_AnyList_item_activated.bind(GroupList))
	SettingList.item_activated.connect(_on_AnyList_item_activated.bind(SettingList))
	
	FilterField.text_changed.connect(_on_FilterField_text_changed)
	MCBtn.toggled.connect(_on_MCBtn_toggled)


func _on_about_to_popup() -> void:
	OkBtn.disabled = true
	_populate_list(GroupList)
	_populate_list(SettingList)
	DescField.clear_content()
	FilterField.clear()
	MCBtn.button_pressed = GGS.data.add_item_filtering_match_case


func _on_visibility_changed() -> void:
	if visible == true:
		FilterField.grab_focus()


### Lists/General

func _populate_list(list: ItemList) -> void:
	list.clear()
	
	var base_path: String = GGS.data.dir_settings if list == SettingList else GGS.data.dir_groups
	var setting_files: PackedStringArray = DirAccess.get_files_at(base_path)
	for setting_file in setting_files:
		var script: Script = load(base_path.path_join(setting_file))
		var setting: ggsCatItem = script.new()
		
		var text: String = setting.name
		var icon: Texture2D = setting.icon
		
		var item_index: int = list.add_item(text, icon)
		list.set_item_metadata(item_index, setting)


func _deselect_other_list(list: ItemList) -> void:
	if list == GroupList:
		SettingList.deselect_all()
	else:
		GroupList.deselect_all()


func _on_AnyList_item_selected(index: int, list: ItemList) -> void:
	OkBtn.disabled = false
	DescField.set_content(list.get_item_metadata(index))
	_deselect_other_list(list)


func _on_AnyList_item_activated(index: int, list: ItemList) -> void:
	confirmed.emit()
	hide()


### Lists/Filtering

func _filter_list(list: ItemList, filter: String) -> void:
	_populate_list(list)
	OkBtn.disabled = true
	DescField.clear_content()
	
	var match_case: bool = GGS.data.add_item_filtering_match_case
	if not match_case:
		filter = filter.to_lower()
	
	for item_index in range(list.item_count):
		var item_text: String = list.get_item_text(item_index)
		
		if not match_case:
			item_text = item_text.to_lower()
		
		if not item_text.begins_with(filter):
			list.remove_item(item_index)
	
	list.sort_items_by_text()


func _on_FilterField_text_changed(new_text: String) -> void:
	_filter_list(GroupList, new_text)
	_filter_list(SettingList, new_text)


func _on_MCBtn_toggled(button_state: bool) -> void:
	GGS.data.set_data("add_item_filtering_match_case", button_state)
	_filter_list(GroupList, FilterField.text)
	_filter_list(SettingList, FilterField.text)
