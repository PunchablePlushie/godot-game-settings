@tool
extends ConfirmationDialog
class_name ggsBaseSelectWin

@export_group("Nodes")
@export var FilterField: LineEdit
@export var List: ItemList

var field_value_is_valid: bool

@onready var OkBtn: Button = get_ok_button()


func _init() -> void:
	visible = false
	min_size = Vector2(400, 300)
	unresizable = true


func _ready() -> void:
	confirmed.connect(_on_confirmed)
	visibility_changed.connect(_on_visibility_changed)

	FilterField.text_changed.connect(_on_FilterField_text_changed)
	FilterField.text_submitted.connect(_on_FilterField_text_submitted)

	List.item_selected.connect(_on_List_item_selected)
	List.item_activated.connect(_on_List_item_activated)


func get_selected_item_idx() -> int:
	var selected_items: PackedInt32Array = List.get_selected_items()
	print(selected_items)
	var item_idx: int = 0

	if List.item_count > 1:
		item_idx = selected_items[0]

	return item_idx


func _confirm_selection(selection) -> void:
	pass


func _on_visibility_changed() -> void:
	if visible:
		field_value_is_valid = false
		OkBtn.disabled = true
		FilterField.clear()
		FilterField.grab_focus()
	else:
		queue_free()


func _on_confirmed() -> void:
	pass


# Confirming through filter list #
func _on_FilterField_text_changed(new_text: String) -> void:
	List.filter(new_text)

	field_value_is_valid = (List.item_count == 1)
	OkBtn.disabled = !field_value_is_valid


func _on_FilterField_text_submitted(submitted_text: String) -> void:
	pass


# Confirming through list actions #
func _on_List_item_selected(idx: int) -> void:
	OkBtn.disabled = false


func _on_List_item_activated(index: int) -> void:
	pass
