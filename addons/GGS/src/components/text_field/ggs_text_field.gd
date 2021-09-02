extends LineEdit

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	text = current["value"]
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("text_changed", self, "_on_text_changed")
	connect("mouse_entered", self, "_on_mouse_entered")


func reset_to_default() -> void:
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	_on_text_changed(default["value"])
	text = default["value"]


func _on_text_changed(new_text: String) -> void:
	var current: Dictionary = ggsManager.settings_data[str(setting_index)]["current"]
	current["value"] = new_text
	ggsManager.save_settings_data()
	script_instance.main(current)


# Handle mouse focus
func _on_mouse_entered() -> void:
	grab_focus()
