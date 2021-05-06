extends HBoxContainer

export(int, 0, 99) var setting_index: int
export(Array, String) var list: Array
export(bool) var wrap_value: bool = true

var script_instance: Object
var current_index: int = 0 setget set_current_index

onready var DisplayLabel: Label = $DisplayLabel
onready var PrevBtn: Button = $PrevBtn
onready var NextBtn: Button = $NextBtn


func _ready() -> void:
	# Load display value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	if typeof(current) == TYPE_DICTIONARY:
		current_index = current["value"]
	else:
		current_index = current
	DisplayLabel.text = list[current_index]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	set_current_index(default[1])


func set_current_index(value: int) -> void:
	ggsManager.settings_data[str(setting_index)]["current"][1] = value
	ggsManager.save_settings_data()
	DisplayLabel.text = list[current_index]
	script_instance.main(value)


func _on_PrevBtn_pressed() -> void:
	if wrap_value:
		if current_index == 0:
			self.current_index = list.size() - 1
		else:
			self.current_index -= 1
	else:
		if current_index > 0:
			self.current_index -= 1


func _on_NextBtn_pressed() -> void:
	if wrap_value:
		if current_index == list.size() - 1:
			self.current_index = 0
		else:
			self.current_index += 1
	else:
		if current_index < list.size() - 1:
			self.current_index += 1
