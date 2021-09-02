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
	DisplayLabel.text = list[current["value"]]
	current_index = current["value"]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Handle mouse filter and cursor
	PrevBtn.mouse_filter = mouse_filter
	NextBtn.mouse_filter = mouse_filter
	PrevBtn.mouse_default_cursor_shape = mouse_default_cursor_shape
	NextBtn.mouse_default_cursor_shape = mouse_default_cursor_shape


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	self.current_index = default["value"]


func set_current_index(value: int) -> void:
	current_index = value
	
	var current: Dictionary = ggsManager.settings_data[str(setting_index)]["current"]
	current["value"] = value
	ggsManager.save_settings_data()
	DisplayLabel.text = list[value]
	script_instance.main(current)


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


# Handle mouse focus
func _on_PrevBtn_mouse_entered() -> void:
	PrevBtn.grab_focus()


func _on_NextBtn_mouse_entered() -> void:
	NextBtn.grab_focus()
