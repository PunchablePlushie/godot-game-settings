extends Button

export(int, 0, 99) var setting_index: int
var script_instance: Object

# Resources
onready var ConfirmPopup: PackedScene = preload("KeybindConfirm.tscn")
const mouse_btn_names := {"1": "Left Mouse Button", "2": "Right Mouse Button", "3": "Middle Mouse Button",
							"4": "Mouse Wheel Up", "5": "Mouse Wheel Down", "6": "Mouse Wheel Left",
							"7": "Mouse Wheel Right", "8": "Mouse Extra Button 1", "9": "Mouse Extra Button 2"}


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
			text = mouse_btn_names[str(value)]
	
	# Load Script
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	script_instance = script.new()
	
	# Connect signal
	connect("pressed", self, "_on_pressed")


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
			text = mouse_btn_names[str(event.button_index)]
	
	# Execute the logic script
	script_instance.main(current)


func _on_Button_button_down():
	pass # Replace with function body.
