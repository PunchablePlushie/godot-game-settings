@tool
@icon("res://addons/ggs/plugin/assets/option_list.svg")
extends ggsComponent

## If true, the component will use the item IDs instead of their index as
## the setting value.
@export var _use_ids: bool = false

@onready var _Btn: OptionButton = $Btn


func _ready() -> void:
	compatible_types = [TYPE_BOOL, TYPE_INT]
	if Engine.is_editor_hint():
		return

	init_value()
	_Btn.item_selected.connect(_on_Btn_item_selected)

	_Btn.pressed.connect(_on_Btn_pressed)
	_Btn.mouse_entered.connect(_on_Btn_mouse_entered)
	_Btn.focus_entered.connect(_on_Btn_focus_entered)
	_Btn.item_focused.connect(_on_Btn_item_focused)


func init_value() -> void:
	value = GGS.get_value(setting)

	if _use_ids:
		_Btn.select(_Btn.get_item_index(value))
	else:
		_Btn.select(value)


func reset_setting() -> void:
	super()
	_Btn.select(value)


func _on_Btn_item_selected(item_index: int) -> void:
	GGS.Audio.Interact.play()

	if _use_ids:
		value = _Btn.get_item_id(item_index)
	else:
		value = item_index
	if apply_on_changed:
		apply_setting()


func _on_Btn_pressed() -> void:
	GGS.Audio.FocusEntered.play()


func _on_Btn_mouse_entered() -> void:
	GGS.Audio.MouseEntered.play()

	if grab_focus_on_mouse_over:
		_Btn.grab_focus()


func _on_Btn_focus_entered() -> void:
	GGS.Audio.FocusEntered.play()


func _on_Btn_item_focused(_index: int) -> void:
	GGS.Audio.FocusEntered.play()
