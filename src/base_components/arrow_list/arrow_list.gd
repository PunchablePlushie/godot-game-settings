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
	if starts_with_focus:
		prev_btn.grab_focus()
	
	_current_value = SettingsManager.get_setting(section_name, key_name)
	current_value_node.text = options_list[_current_value]
	prev_btn.connect("pressed", self, "_on_PrevBtn_pressed")
	next_btn.connect("pressed", self, "_on_NextBtn_pressed")


func update_value(new_value: int) -> void:
	current_value_node.text = options_list[new_value]
	SettingsManager.set_setting(section_name, key_name, new_value)


func _on_PrevBtn_pressed() -> void:
	if wrap_value:
		SettingsManager.play_sfx(0)
		if _current_value == 0:
			_current_value = options_list.size() - 1
		else:
			_current_value -= 1
	else:
		if _current_value > 0:
			_current_value -= 1
			SettingsManager.play_sfx(0)
		else:
			SettingsManager.play_sfx(2)
	update_value(_current_value)


func _on_NextBtn_pressed() -> void:
	if wrap_value:
		SettingsManager.play_sfx(0)
		if _current_value == options_list.size() - 1:
			_current_value = 0
		else:
			_current_value += 1
	else:
		if _current_value < options_list.size() - 1:
			_current_value += 1
			SettingsManager.play_sfx(0)
		else:
			SettingsManager.play_sfx(2)
	update_value(_current_value)
