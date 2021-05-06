extends LineEdit

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	text = current
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("text_changed", self, "_on_text_changed")


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	ggsManager.settings_data[str(setting_index)]["current"] = default
	text = default
	ggsManager.save_settings_data()
	script_instance.main(default)


func _on_text_changed(new_text: String) -> void:
	ggsManager.settings_data[str(setting_index)]["current"] = new_text
	ggsManager.save_settings_data()
	script_instance.main(new_text)
