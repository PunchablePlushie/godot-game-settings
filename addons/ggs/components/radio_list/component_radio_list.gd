@tool
@icon("res://addons/ggs/plugin/assets/radio_list.svg")
extends ggsComponent

enum Lists {HLIST, VLIST}

## If not empty, IDs in this list are used instead of indices when saving
## list items. This array must be the same size as the number of children
## in the active list.
@export var option_ids: PackedInt32Array

## The children of the active list will be used as the list items.
@export var active_list: Lists = Lists.HLIST

var _ActiveList: BoxContainer

@onready var _HList: HBoxContainer = $HList
@onready var _VList: VBoxContainer = $VList
@onready var _btngrp: ButtonGroup = ButtonGroup.new()


func _ready() -> void:
	compatible_types = [TYPE_BOOL, TYPE_INT]
	if Engine.is_editor_hint():
		return

	if active_list == Lists.HLIST:
		_ActiveList = _HList
	else:
		_ActiveList = _VList

	init_value()
	_btngrp.pressed.connect(_on_BtnGroup_pressed)

	for child: Button in _ActiveList.get_children():
		child.button_group = _btngrp

		child.mouse_entered.connect(_on_AnyBtn_mouse_entered.bind(child))
		child.focus_entered.connect(_on_AnyBtn_focus_entered)


func init_value() -> void:
	value = GGS.get_value(setting)
	if not option_ids.is_empty():
		_set_button_pressed(option_ids.find(value), true)
	else:
		_set_button_pressed(value, true)


func reset_setting() -> void:
	super()
	_set_button_pressed(value, true)


func _set_button_pressed(btn_index: int, pressed: bool) -> void:
	_ActiveList.get_child(btn_index).set_pressed_no_signal(pressed)


func _get_child_index(target_child: BaseButton) -> int:
	var i: int = 0
	for child: Button in _ActiveList.get_children():
		if child == target_child:
			return i

		i += 1

	return -1


func _on_BtnGroup_pressed(button: BaseButton) -> void:
	GGS.Audio.Interact.play()

	var child_index: int = _get_child_index(button)
	if not option_ids.is_empty():
		value = option_ids[child_index]
	else:
		value = child_index

	if apply_on_changed:
		apply_setting()


func _on_AnyBtn_mouse_entered(Btn: Button) -> void:
	GGS.Audio.MouseEntered.play()

	if grab_focus_on_mouse_over:
		Btn.grab_focus()


func _on_AnyBtn_focus_entered() -> void:
	GGS.Audio.FocusEntered.play()
