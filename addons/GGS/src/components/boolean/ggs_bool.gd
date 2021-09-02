extends CheckButton

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current: Dictionary = ggsManager.settings_data[str(setting_index)]["current"]
	pressed = current["value"]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("toggled", self, "_on_toggled")
	connect("mouse_entered", self, "_on_mouse_entered")


func reset_to_default() -> void:
	var default: Dictionary = ggsManager.settings_data[str(setting_index)]["default"]
	_on_toggled(default["value"])
	pressed = default["value"]


func _on_toggled(button_pressed: bool) -> void:
	var current: Dictionary = ggsManager.settings_data[str(setting_index)]["current"]
	current["value"] = button_pressed
	ggsManager.save_settings_data()
	script_instance.main(current)


# Handle mouse focus
func _on_mouse_entered() -> void:
	grab_focus()
