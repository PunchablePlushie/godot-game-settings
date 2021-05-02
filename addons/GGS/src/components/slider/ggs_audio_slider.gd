extends HSlider

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	
	if current == null:
		value = default[1]
	else:
		value = current[1]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("value_changed", self, "_on_value_changed")


func _on_value_changed(value: float) -> void:
	# Update save value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var target_bus = ggsManager.settings_data[str(setting_index)]["default"][0]
	if current == null:
		ggsManager.settings_data[str(setting_index)]["current"] = [target_bus, value]
	else:
		ggsManager.settings_data[str(setting_index)]["current"][1] = value
	ggsManager.save_settings_data()
	
	# Execute logic
	script_instance.main(ggsManager.settings_data[str(setting_index)]["current"])
