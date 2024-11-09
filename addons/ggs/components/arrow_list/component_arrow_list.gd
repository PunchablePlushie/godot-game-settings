@tool
@icon("res://addons/ggs/plugin/assets/arrow_list.svg")
extends ggsComponent

signal option_selected(option_index: int)

## Options of the list. Note that the option index or id is saved, not its
## string label.
@export var options: PackedStringArray

## If not empty, IDs in this list are used instead of indices when saving
## option list items. This array must be the same size as [member options].
@export var option_ids: PackedInt32Array

@onready var _LeftBtn: Button = $HBox/LeftBtn
@onready var _OptionLabel: Label = $HBox/OptionLabel
@onready var _RightBtn: Button = $HBox/RightBtn


func _ready() -> void:
	compatible_types = [TYPE_BOOL, TYPE_INT]
	if Engine.is_editor_hint():
		return

	if (
		not option_ids.is_empty()
		and option_ids.size() != options.size()
	):
		printerr("GGS - Option List (%s): `option_ids` and `options` are not the same size."%name)
		return

	_init_value()
	option_selected.connect(_on_option_selected)
	_LeftBtn.pressed.connect(_on_LeftBtn_pressed)
	_RightBtn.pressed.connect(_on_RightBtn_pressed)

	_LeftBtn.mouse_entered.connect(_on_AnyBtn_mouse_entered.bind(_LeftBtn))
	_RightBtn.mouse_entered.connect(_on_AnyBtn_mouse_entered.bind(_RightBtn))
	_LeftBtn.focus_entered.connect(_on_AnyBtn_focus_entered)
	_RightBtn.focus_entered.connect(_on_AnyBtn_focus_entered)


func reset_setting() -> void:
	_select(setting.default)
	apply_setting()


func _init_value() -> void:
	value = GGS.get_value(setting)

	if not option_ids.is_empty():
		var option_idx: int = option_ids.find(value)
		_select(option_idx, false)
	else:
		_select(value, false)


func _select(index: int, emit_selected: bool = true) -> void:
	index = index % options.size()

	_OptionLabel.text = options[index]

	if not option_ids.is_empty():
		value = option_ids[index]
	else:
		value = index

	if emit_selected:
		option_selected.emit(index)


func _on_option_selected(_option_index: int) -> void:
	if apply_on_changed:
		apply_setting()


func _on_LeftBtn_pressed() -> void:
	if option_ids.is_empty():
		_select(value - 1)
	else:
		_select(option_ids.find(value) - 1)

	GGS.Audio.Interact.play()


func _on_RightBtn_pressed() -> void:
	if option_ids.is_empty():
		_select(value + 1)
	else:
		_select(option_ids.find(value) + 1)

	GGS.Audio.Interact.play()


func _on_AnyBtn_mouse_entered(Btn: Button) -> void:
	GGS.Audio.MouseEntered.play()

	if grab_focus_on_mouse_over:
		Btn.grab_focus()


func _on_AnyBtn_focus_entered() -> void:
	GGS.Audio.FocusEntered.play()
