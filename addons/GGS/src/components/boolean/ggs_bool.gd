extends CheckButton

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	pressed = current
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("toggled", self, "_on_toggled")


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	ggsManager.settings_data[str(setting_index)]["current"] = default
	pressed = default
	ggsManager.save_settings_data()
	script_instance.main(default)


func _on_toggled(button_pressed: bool) -> void:
	ggsManager.settings_data[str(setting_index)]["current"] = button_pressed
	ggsManager.save_settings_data()
	script_instance.main(button_pressed)
