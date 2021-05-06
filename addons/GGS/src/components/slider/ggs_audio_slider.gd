extends HSlider

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	value = current[1]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("value_changed", self, "_on_value_changed")


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	value = default[1]
	ggsManager.save_settings_data()
	script_instance.main(ggsManager.settings_data[str(setting_index)]["default"])


func _on_value_changed(value: float) -> void:
	# Update save value
	ggsManager.settings_data[str(setting_index)]["current"][1] = value
	ggsManager.save_settings_data()
	
	# Execute logic
	script_instance.main(ggsManager.settings_data[str(setting_index)]["current"])
