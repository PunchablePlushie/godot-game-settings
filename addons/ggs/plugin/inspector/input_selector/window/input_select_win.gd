@tool
extends ConfirmationDialog

signal input_confirmed(action: String)

@export_subgroup("Internal")
@export var _FilterField: LineEdit
@export var _List: ItemList

var _field_value_is_valid: bool

@onready var OkBtn: Button = get_ok_button()


func _init() -> void:
	visible = false


func _ready() -> void:
	confirmed.connect(_on_confirmed)
	visibility_changed.connect(_on_visibility_changed)
	
	_FilterField.text_changed.connect(_on_FilterField_text_changed)
	_FilterField.text_submitted.connect(_on_FilterField_text_submitted)
	
	_List.item_selected.connect(_on_List_item_selected)
	_List.item_activated.connect(_on_List_item_activated)


func _confirm_selection(selection: String) -> void:
	input_confirmed.emit(selection)
	hide()


func _on_visibility_changed() -> void:
	if visible:
		_field_value_is_valid = false
		
		popup_centered()
		
		OkBtn.disabled = true
		_FilterField.clear()
		_FilterField.grab_focus()
	else:
		queue_free()


func _on_confirmed() -> void:
	var selected_items: PackedInt32Array = _List.get_selected_items()
	var item_idx: int = 0
	
	if _List.item_count > 1:
		item_idx = selected_items[0]
	
	var item: String = _List.get_item_text(item_idx)
	_confirm_selection(item)


# Confirming through filter list #
func _on_FilterField_text_changed(new_text: String) -> void:
	_List.filter(new_text)
	
	_field_value_is_valid = (_List.item_count == 1)
	OkBtn.disabled = !_field_value_is_valid


func _on_FilterField_text_submitted(submitted_text: String) -> void:
	if _field_value_is_valid:
		var item: String = _List.get_item_text(0)
		_confirm_selection(item)


# Confirming through list actions #
func _on_List_item_selected(idx: int) -> void:
	OkBtn.disabled = false


func _on_List_item_activated(index: int) -> void:
	var item: String = _List.get_item_text(index)
	_confirm_selection(item)
