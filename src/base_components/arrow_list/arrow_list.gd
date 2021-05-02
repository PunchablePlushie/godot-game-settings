class_name ArrowList222
extends BaseComponent

export(bool) var wrap_value: bool = true
export(Array, String) var options_list: Array

var current_value: int

onready var setting: Node = GameSettings.find_node(setting_node)
onready var label: Label = $Label
onready var current_value_node: Label = $HBoxContainer/CurrentValue
onready var prev_btn: Button = $HBoxContainer/PrevBtn
onready var next_btn: Button = $HBoxContainer/NextBtn


func _ready() -> void:
	if starts_with_focus:
		prev_btn.grab_focus()
	
	current_value = GameSettings.get_setting(setting.section, setting.key)
	current_value_node.text = options_list[current_value]
	prev_btn.connect("pressed", self, "_on_PrevBtn_pressed")
	next_btn.connect("pressed", self, "_on_NextBtn_pressed")


func update_value(new_value: int) -> void:
	current_value_node.text = options_list[new_value]
	GameSettings.set_setting(setting.section, setting.key, new_value)


func _on_PrevBtn_pressed() -> void:
	if wrap_value:
		if current_value == 0:
			current_value = options_list.size() - 1
		else:
			current_value -= 1
	else:
		if current_value > 0:
			current_value -= 1
	update_value(current_value)


func _on_NextBtn_pressed() -> void:
	if wrap_value:
		if current_value == options_list.size() - 1:
			current_value = 0
		else:
			current_value += 1
	else:
		if current_value < options_list.size() - 1:
			current_value += 1
	update_value(current_value)
