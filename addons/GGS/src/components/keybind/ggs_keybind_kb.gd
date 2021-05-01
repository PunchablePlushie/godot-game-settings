extends Button

export(int, 0, 99) var setting_index: int
var script_instance: Object

# Resources
onready var ConfirmPopup: PackedScene = preload("KeybindConfirm.tscn")


func _ready() -> void:
	# Load and set display value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var value: int
	
	if ggsManager.ggs_data["keyboard_use_glyphs"]:
		pass
	else:
		if current == null:
			value = ggsManager.settings_data[str(setting_index)]["default"][1]
		else:
			value = ggsManager.settings_data[str(setting_index)]["current"][1]
		text = OS.get_scancode_string(value)
	
	# Load Script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("pressed", self, "_on_pressed")


func _on_pressed() -> void:
	var instance: PopupPanel = ConfirmPopup.instance()
	instance.type = 0
	add_child(instance)
	instance.popup_centered()
	instance.connect("confirmed", self, "_on_ConfirmPopup_confirmed", [], CONNECT_ONESHOT)


func _on_ConfirmPopup_confirmed(event: InputEventKey) -> void:
	# Update save value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var target_action = ggsManager.settings_data[str(setting_index)]["default"][0]
	if current == null:
		ggsManager.settings_data[str(setting_index)]["current"] = [target_action, event.scancode]
	else:
		ggsManager.settings_data[str(setting_index)]["current"][1] = event.scancode
	ggsManager.save_settings_data()
	
	# Update display value
	if ggsManager.ggs_data["keyboard_use_glyphs"]:
		pass
	else:
		text = ggsManager.gp_get_text(Input.get_joy_button_string(event.button_index))
	
	# Execute the logic script
	script_instance.main(ggsManager.settings_data[str(setting_index)]["current"])
