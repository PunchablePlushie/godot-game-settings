@tool
extends ConfirmationDialog

@export_group("Nodes")
@export var _Events: Node
@export_subgroup("Internal")
@export var _FilterField: LineEdit
@export var _List: ItemList

var _field_value_is_valid: bool
var _types: PackedStringArray = ggsUtils.get_all_types()

@onready var OkBtn: Button = get_ok_button()


func _init() -> void:
	visible = false


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	confirmed.connect(_on_confirmed)
	_Events.type_selector_requested.connect(_on_Global_type_selector_requested)
	
	_FilterField.text_changed.connect(_on_FilterField_text_changed)
	_FilterField.text_submitted.connect(_on_FilterField_text_submitted)
	
	_List.item_selected.connect(_on_List_item_selected)
	_List.item_activated.connect(_on_List_item_activated)


func _confirm_selection(selection: Variant.Type) -> void:
	_Events.type_selector_confirmed.emit(selection)
	hide()


func _on_Global_type_selector_requested() -> void:
	popup_centered()


func _on_visibility_changed() -> void:
	if visible:
		OkBtn.disabled = true
		_field_value_is_valid = false
		_FilterField.clear()
		_FilterField.grab_focus()


func _on_confirmed() -> void:
	if _List.item_count == 1:
		var item: String = _List.get_item_text(0)
		var idx: int = _types.find(item)
		_confirm_selection(idx)
		return
	
	var selected: int = _List.get_selected_items()[0]
	_confirm_selection(selected)


# Confirming through filter list #
func _on_FilterField_text_changed(new_text: String) -> void:
	_List.filter(new_text)
	
	_field_value_is_valid = (_List.item_count == 1)
	OkBtn.disabled = !_field_value_is_valid


func _on_FilterField_text_submitted(submitted_text: String) -> void:
	if _field_value_is_valid:
		var item: String = _List.get_item_text(0)
		var idx: int = _types.find(item)
		_confirm_selection(idx)


# Confirming through list actions #
func _on_List_item_selected(idx: int) -> void:
	OkBtn.disabled = false


func _on_List_item_activated(index: int) -> void:
	var item: String = _List.get_item_text(index)
	var idx: int = _types.find(item)
	_confirm_selection(idx)
