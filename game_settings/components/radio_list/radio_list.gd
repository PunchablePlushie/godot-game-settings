extends ggsUIComponent

@onready var BtnList: HBoxContainer = $BtnList
@onready var btngrp: ButtonGroup = ButtonGroup.new()


func _ready() -> void:
	super()
	btngrp.pressed.connect(_on_pressed)
	
	for child in BtnList.get_children():
		child.button_group = btngrp


func init_value() -> void:
	super()
	_set_button_pressed(setting_value, true)


func _set_button_pressed(btn_index: int, pressed: bool) -> void:
	BtnList.get_child(btn_index).button_pressed = pressed


func _get_child_index(target_child: BaseButton) -> int:
	var i: int = 0
	for child in BtnList.get_children():
		if child == target_child:
			return i
		
		i += 1
	
	return -1


func _on_pressed(button: BaseButton) -> void:
	var child_index: int = _get_child_index(button)
	setting_value = child_index
	
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	_set_button_pressed(setting_value, true)
