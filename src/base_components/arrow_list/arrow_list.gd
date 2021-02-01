class_name ArrowList
extends BaseComponent

export(Array, String) var options_list: Array
export(bool) var wrap_value: bool = true

var _current_value: int

onready var label: Label = $Label
onready var current_value_node: Label = $HBoxContainer/CurrentValue
onready var prev_btn: Button = $HBoxContainer/PrevBtn
onready var next_btn: Button = $HBoxContainer/NextBtn

func _ready() -> void:
	label.text = setting_name
	_current_value = SettingsManager.get_setting(section_name, key_name)
	current_value_node.text = options_list[_current_value]


func update_value(new_value: int) -> void:
	current_value_node.text = options_list[new_value]
	SettingsManager.set_setting(section_name, key_name, new_value)


func _on_PrevBtn_pressed() -> void:
#	_current_value = (_current_value - 1) % options_list.size()
	if wrap_value:
		if _current_value == 0:
			_current_value = options_list.size() - 1
		else:
			_current_value -= 1
	else:
		if _current_value > 0:
			_current_value -= 1
	update_value(_current_value)


func _on_NextBtn_pressed() -> void:
#	_current_value = (_current_value + 1) % options_list.size()
	if wrap_value:
		if _current_value == options_list.size() - 1:
			_current_value = 0
		else:
			_current_value += 1
	else:
		if _current_value < options_list.size() - 1:
			_current_value += 1
	update_value(_current_value)
