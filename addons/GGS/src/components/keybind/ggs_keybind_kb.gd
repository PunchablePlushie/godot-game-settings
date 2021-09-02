extends Button

export(int, 0, 99) var setting_index: int
var script_instance: Object

# Resources
onready var ConfirmPopup: PackedScene = preload("KeybindConfirm.tscn")


func _ready() -> void:
	# Load and set display value
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var value: int
	value = current["value"]
	
	if icon != null:
		icon.current_frame = value
	else:
		if value > 24:
			text = OS.get_scancode_string(value)
		else:
			text = _get_mouse_button_string(value)
	
	# Load Script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("pressed", self, "_on_pressed")
	connect("mouse_entered", self, "_on_mouse_entered")


func reset_to_default() -> void:
	var default: Dictionary = ggsManager.settings_data[str(setting_index)]["default"]
	var event: InputEventWithModifiers
	if default["value"] > 24:
		event = InputEventKey.new()
		event.scancode = default["value"]
	else:
		event = InputEventMouseButton.new()
		event.button_index = default["value"]
	_on_ConfirmPopup_confirmed(event)


# Handle mouse focus
func _on_mouse_entered() -> void:
	grab_focus()


func _on_pressed() -> void:
	var instance: PopupPanel = ConfirmPopup.instance()
	instance.type = 0
	instance.source = self
	add_child(instance)
	instance.popup_centered()
	instance.connect("confirmed", self, "_on_ConfirmPopup_confirmed", [], CONNECT_ONESHOT)
	release_focus()


func _on_ConfirmPopup_confirmed(event: InputEventWithModifiers) -> void:
	# Update save value
	var current: Dictionary = ggsManager.settings_data[str(setting_index)]["current"]
	if event is InputEventKey:
		current["value"] = event.scancode
	else:
		current["value"] = event.button_index
	ggsManager.save_settings_data()
	
	# Update display value
	if icon != null:
		if event is InputEventKey:
			icon.current_frame = event.scancode
		else:
			icon.current_frame = event.button_index
	else:
		if event is InputEventKey:
			text = OS.get_scancode_string(event.scancode)
		else:
			text = _get_mouse_button_string(event.button_index)
	
	# Execute the logic script
	script_instance.main(current)


func _get_mouse_button_string(button_index: int) -> String:
	var strings: Dictionary = {
		"1": "LMB",
		"2": "RMB",
		"3": "MMB",
		"4": "MW Up",
		"5": "MW Down",
		"6": "MW Left",
		"7": "MW Right",
		"8": "Mouse Extra 1",
		"9": "Mouse Extra 2",
	}
	return strings[str(button_index)]
