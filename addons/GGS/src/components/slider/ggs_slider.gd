extends HSlider

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	value = current["value"]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("value_changed", self, "_on_value_changed")
	connect("mouse_entered", self, "_on_mouse_entered")


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	_on_value_changed(default["value"])
	value = default["value"]


func _on_value_changed(value: float) -> void:
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	current["value"] = value
	ggsManager.save_settings_data()
	script_instance.main(current)


# Handle mouse focus
func _on_mouse_entered() -> void:
	grab_focus()
