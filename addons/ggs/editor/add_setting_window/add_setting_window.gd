@tool
extends ConfirmationDialog

var selected_setting: ggsSetting: set = _set_selected_setting

@onready var List: ItemList = %SettingList
@onready var DescField: RichTextLabel = %DescField
@onready var FilterField: LineEdit = %FilterField
@onready var OkBtn: Button = get_ok_button()


func _init() -> void:
	hide()


func _ready() -> void:
	about_to_popup.connect(_on_about_to_popup)
	visibility_changed.connect(_on_visibility_changed)
	
	List.item_selected.connect(_on_List_item_selected)
	List.item_activated.connect(_on_List_item_activated)
	
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
	_populate_list()


func _on_visibility_changed() -> void:
	if visible == true:
		FilterField.grab_focus()


### List/General

func _populate_list() -> void:
	List.clear()
	
	var base_path: String = GGS.data.dir_settings
	var setting_files: PackedStringArray = DirAccess.get_files_at(base_path)
	for setting_file in setting_files:
		var script: Script = load(base_path.path_join(setting_file))
		var setting: ggsSetting = script.new()
		
		var text: String = setting.name
		var icon: Texture2D = setting.icon
		
		var item_index: int = List.add_item(text, icon)
		List.set_item_metadata(item_index, setting)


func _on_List_item_selected(index: int) -> void:
	selected_setting = List.get_item_metadata(index)


func _on_List_item_activated(_index: int) -> void:
	confirmed.emit()
	hide()


### Lists/Filtering

func _filter_list(filter: String) -> void:
	_populate_list()
	selected_setting = null
	
	for item_index in range(List.item_count):
		var item_text: String = List.get_item_text(item_index).to_lower()
		
		if not item_text.begins_with(filter.to_lower()):
			List.remove_item(item_index)
	
	List.sort_items_by_text()


func _on_FilterField_text_changed(new_text: String) -> void:
	_filter_list(new_text)
