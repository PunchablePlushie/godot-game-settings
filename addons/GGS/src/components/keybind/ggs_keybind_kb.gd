extends Button

export(int, 0, 99) var setting_index: int
var script_instance: Object

# Resources
onready var ConfirmPopup: PackedScene = preload("KeybindConfirm.tscn")


func _ready() -> void:
	# Load value
	if ggsManager.settings_data[str(setting_index)]["current"] == null:
		var value: int =  ggsManager.settings_data[str(setting_index)]["default"][1]
		text = OS.get_scancode_string(value)
	else:
		var value: int = ggsManager.settings_data[str(setting_index)]["current"][1]
		text = OS.get_scancode_string(value)
	
	# Load Script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("pressed", self, "_on_pressed")


func _on_pressed() -> void:
	var instance: PopupPanel = ConfirmPopup.instance()
	add_child(instance)
	instance.popup_centered()
	instance.connect("confirmed", self, "_on_ConfirmPopup_confirmed", [], CONNECT_ONESHOT)


func _on_ConfirmPopup_confirmed(event: InputEventKey) -> void:
	var cur_value = ggsManager.settings_data[str(setting_index)]["current"]
	var target_action = ggsManager.settings_data[str(setting_index)]["default"][0]
	
	if cur_value == null:
		ggsManager.settings_data[str(setting_index)]["current"] = [target_action, event.scancode]
	else:
		ggsManager.settings_data[str(setting_index)]["current"][1] = event.scancode
	ggsManager.save_settings_data()
	script_instance.main(ggsManager.settings_data[str(setting_index)]["current"])
	
	text = OS.get_scancode_string(event.scancode)
