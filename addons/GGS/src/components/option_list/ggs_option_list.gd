extends OptionButton

export(int, 0, 99) var setting_index: int
var script_instance: Object


func _ready() -> void:
	# Load value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var default = ggsManager.settings_data[str(setting_index)]["default"]
	
	if current == null:
		selected = default
	else:
		selected = current
	
	# Load script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("item_selected", self, "_on_item_selected")


func _on_item_selected(index: int) -> void:
	ggsManager.settings_data[str(setting_index)]["current"] = index
	ggsManager.save_settings_data()
	script_instance.main(index)
