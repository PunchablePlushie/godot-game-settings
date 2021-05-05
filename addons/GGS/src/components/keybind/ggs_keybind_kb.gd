extends Button

export(int, 0, 99) var setting_index: int
var script_instance: Object

# Resources
onready var ConfirmPopup: PackedScene = preload("KeybindConfirm.tscn")


func _ready() -> void:
	# Load and set display value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var value: int
	value = current[1]
	
	if icon != null:
		icon.current_frame = value
	else:
		text = OS.get_scancode_string(value)
	
	# Load Script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("pressed", self, "_on_pressed")


func _on_pressed() -> void:
	var instance: PopupPanel = ConfirmPopup.instance()
	instance.type = 0
	instance.source = self
	add_child(instance)
	instance.popup_centered()
	instance.connect("confirmed", self, "_on_ConfirmPopup_confirmed", [], CONNECT_ONESHOT)
	release_focus()


func _on_ConfirmPopup_confirmed(event: InputEventKey) -> void:
	# Update save value
	ggsManager.settings_data[str(setting_index)]["current"][1] = event.scancode
	ggsManager.save_settings_data()
	
	# Update display value
	if icon != null:
		icon.current_frame = event.scancode
	else:
		text = OS.get_scancode_string(event.scancode)
	
	# Execute the logic script
	script_instance.main(ggsManager.settings_data[str(setting_index)]["current"])
