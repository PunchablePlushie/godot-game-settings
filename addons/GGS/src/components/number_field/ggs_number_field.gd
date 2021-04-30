extends SpinBox

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	if ggsManager.settings_data[str(setting_index)]["current"] == null:
		value = ggsManager.str2correct(ggsManager.settings_data[str(setting_index)]["default"])
	else:
		value = ggsManager.settings_data[str(setting_index)]["current"]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("value_changed", self, "_on_value_changed")


func _on_value_changed(value: float) -> void:
	ggsManager.settings_data[str(setting_index)]["current"] = value
	ggsManager.save_settings_data()
	script_instance.main(value)
