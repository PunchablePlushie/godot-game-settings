extends HBoxContainer

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var setting_value: int

@onready var save_section: String = setting.category
@onready var save_key: String = setting.name
@onready var btngrp: ButtonGroup = ButtonGroup.new()


func _ready() -> void:
	btngrp.pressed.connect(_on_pressed)
	
	for child in get_children():
		child.button_group = btngrp
	
	_init_value()


func _init_value() -> void:
	setting_value = ggsSaveFile.new().get_key(save_section, save_key)
	_set_button_pressed(setting_value, true)


func _set_button_pressed(btn_index: int, pressed: bool) -> void:
	get_child(btn_index).button_pressed = pressed


func _get_child_index(target_child: BaseButton) -> int:
	var i: int = 0
	for child in get_children():
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

func apply_setting() -> void:
	setting.current = setting_value
	setting.apply(setting_value)


func reset_setting() -> void:
	setting_value = setting.default
	_set_button_pressed(setting_value, true)
	apply_setting()
