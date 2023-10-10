@tool
extends MarginContainer

var inspected_obj: ggsInputSetting

@onready var SelectBtn: Button = %SelectBtn

@onready var SIW: ConfirmationDialog = %SelectInputWindow
@onready var SearchField: LineEdit = %SearchField
@onready var CollapseAllBtn: Button = %CollapseAllBtn
@onready var ExpandAllBtn: Button = %ExpandAllBtn
@onready var List: Tree = %InputList

@onready var OkBtn: Button = SIW.get_ok_button()


func _ready() -> void:
	SelectBtn.pressed.connect(_on_SelectBtn_pressed)
	
	SIW.about_to_popup.connect(_on_SIW_about_to_popup)
	SIW.confirmed.connect(_on_SIW_confirmed)
	SearchField.text_changed.connect(_on_SearchField_text_changed)
	CollapseAllBtn.pressed.connect(_on_CollapseAllBtn_pressed)
	ExpandAllBtn.pressed.connect(_on_ExpandAllBtn_pressed)
	
	List.item_selected.connect(_on_List_item_selected)
	List.item_activated.connect(_on_List_item_activated)


func _on_SelectBtn_pressed() -> void:
	SIW.popup_centered()


func _on_SIW_about_to_popup() -> void:
	List.load_list()
	OkBtn.disabled = true
	SearchField.clear()
	List.set_collapsed_all(true)


func _on_List_item_selected() -> void:
	var selected_item: TreeItem = List.get_selected()
	OkBtn.disabled = false


### Item Selection

func _confirm(item: TreeItem) -> void:
	inspected_obj.action = item.get_parent().get_text(0)
	inspected_obj.event_index = item.get_metadata(0)["index"]
	inspected_obj.default_as_event = item.get_metadata(0)["event"]
	inspected_obj.current_as_event = item.get_metadata(0)["event"].duplicate()


func _on_SIW_confirmed() -> void:
	var selected_item: TreeItem = List.get_selected()
	_confirm(selected_item)


func _on_List_item_activated() -> void:
	var selected_item: TreeItem = List.get_selected()
	_confirm(selected_item)
	SIW.visible = false


### List Filtering

func _filter_list(filter: String) -> void:
	List.load_list()
	OkBtn.disabled = true
	
	filter = filter.to_lower()
	var items: Array[TreeItem] = List.root.get_children()
	for item in items:
		var item_name: String = item.get_text(0).to_lower()
		if item_name.begins_with(filter):
			continue
		
		item.free()


func _on_SearchField_text_changed(new_text: String) -> void:
	_filter_list(new_text)


### Collapse/Expand Buttons

func _on_CollapseAllBtn_pressed() -> void:
	List.set_collapsed_all(true)


func _on_ExpandAllBtn_pressed() -> void:
	List.set_collapsed_all(false)
