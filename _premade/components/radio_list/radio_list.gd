@tool
extends ggsUIComponent

enum Lists {HLIST, VLIST}

@export var option_ids: PackedInt32Array
@export var active_list: Lists = Lists.HLIST

var ActiveList: BoxContainer

@onready var HList: HBoxContainer = $HList
@onready var VList: VBoxContainer = $VList
@onready var btngrp: ButtonGroup = ButtonGroup.new()


func _ready() -> void:
	compatible_types = [TYPE_BOOL, TYPE_INT]
	if Engine.is_editor_hint():
		return
	
	@warning_ignore("incompatible_ternary")
	ActiveList = HList if active_list == Lists.HLIST else VList
	
	super()
	btngrp.pressed.connect(_on_pressed)
	
	for child in ActiveList.get_children():
		child.button_group = btngrp
		
		child.mouse_entered.connect(_on_AnyBtn_mouse_entered.bind(child))
		child.focus_entered.connect(_on_AnyBtn_focus_entered)


func init_value() -> void:
	super()
	
	if not option_ids.is_empty():
		_set_button_pressed(option_ids.find(setting_value), true)
	else:
		_set_button_pressed(setting_value, true)


func _set_button_pressed(btn_index: int, pressed: bool) -> void:
	ActiveList.get_child(btn_index).button_pressed = pressed


func _get_child_index(target_child: BaseButton) -> int:
	var i: int = 0
	for child in ActiveList.get_children():
		if child == target_child:
			return i
		
		i += 1
	
	return -1


func _on_pressed(button: BaseButton) -> void:
	GGS.play_sfx(GGS.SFX.INTERACT)
	
	var child_index: int = _get_child_index(button)
	if not option_ids.is_empty():
		setting_value = option_ids[child_index]
	else:
		setting_value = child_index
	
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	_set_button_pressed(setting_value, true)


### SFX

func _on_AnyBtn_mouse_entered(Btn: Button) -> void:
	GGS.play_sfx(GGS.SFX.MOUSE_OVER)
	
	if grab_focus_on_mouse_over:
		Btn.grab_focus()


func _on_AnyBtn_focus_entered() -> void:
	GGS.play_sfx(GGS.SFX.FOCUS)
