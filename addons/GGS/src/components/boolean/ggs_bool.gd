extends CheckButton

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	if ggsManager.settings_data[str(setting_index)]["current"] == null:
		pressed = ggsManager.str2correct(ggsManager.settings_data[str(setting_index)]["default"])
	else:
		pressed = ggsManager.settings_data[str(setting_index)]["current"]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("toggled", self, "_on_toggled")


func _on_toggled(button_pressed: bool) -> void:
	ggsManager.settings_data[str(setting_index)]["current"] = button_pressed
	ggsManager.save_settings_data()
	script_instance.main(button_pressed)
