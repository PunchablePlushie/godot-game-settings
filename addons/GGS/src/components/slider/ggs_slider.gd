extends HSlider

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	value = current
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("value_changed", self, "_on_value_changed")


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	ggsManager.settings_data[str(setting_index)]["current"] = default
	value = default
	ggsManager.save_settings_data()
	script_instance.main(default)


func _on_value_changed(value: float) -> void:
	ggsManager.settings_data[str(setting_index)]["current"] = value
	ggsManager.save_settings_data()
	script_instance.main(value)
