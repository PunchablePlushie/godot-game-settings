@tool
extends ConfirmationDialog

@export_group("Nodes")
@export var _Events: Node
@export_subgroup("Internal")
@export var _FilterField: LineEdit
@export var _List: ItemList

var _field_value_is_valid: bool

@onready var OkBtn: Button = get_ok_button()


func _init() -> void:
	visible = false


func _ready() -> void:
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
	_field_value_is_valid = false
	
	popup_centered()
	
	OkBtn.disabled = true
	_FilterField.clear()
	_FilterField.grab_focus()


func _on_confirmed() -> void:
	var selected_items: PackedInt32Array = _List.get_selected_items()
	var item_idx: int = 0
	
	if _List.item_count > 1:
		item_idx = selected_items[0]
	
	var item: String = _List.get_item_text(item_idx)
	var hint_idx = ggsUtils.ALL_TYPES.find_key(item)
	_confirm_selection(hint_idx)


# Confirming through filter list #
func _on_FilterField_text_changed(new_text: String) -> void:
	_List.filter(new_text)
	
	_field_value_is_valid = (_List.item_count == 1)
	OkBtn.disabled = !_field_value_is_valid


func _on_FilterField_text_submitted(submitted_text: String) -> void:
	if _field_value_is_valid:
		var item: String = _List.get_item_text(0)
		var idx: int = ggsUtils.ALL_TYPES.find_key(item)
		_confirm_selection(idx)


# Confirming through list actions #
func _on_List_item_selected(idx: int) -> void:
	OkBtn.disabled = false


func _on_List_item_activated(index: int) -> void:
	var item: String = _List.get_item_text(index)
	var idx: int = ggsUtils.ALL_TYPES.find_key(item)
	_confirm_selection(idx)
