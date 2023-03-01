extends HBoxContainer

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var value: int

@onready var section: String = setting.category
@onready var key: String = setting.name
@onready var btngrp: ButtonGroup = ButtonGroup.new()


func _ready() -> void:
	btngrp.pressed.connect(_on_pressed)
	
	for child in get_children():
		child.button_group = btngrp
	
	value = ggsSaveFile.new().get_key(section, key)
	_set_button_pressed(value, true)


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
	value = child_index
	
	if apply_on_change:
		apply()


### Setting

func apply() -> void:
	setting.current = value
	setting.apply(value)


func reset() -> void:
	value = setting.default
	_set_button_pressed(value, true)
	apply()
