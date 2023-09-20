@tool
extends ggsSetting

enum Type {KEYBOARD, GAMEPAD}

@export var action: String: set = set_action
@export var type: Type: set = set_type


func _init() -> void:
	name = "Input Binding"
	icon = preload("res://addons/ggs/assets/game_settings/input_setting.svg")
	desc = "Rebind keyboard or gamepad input of a specific input action."
	
	value_type = TYPE_STRING
	default = ""


func apply(value: String) -> void:
	var input_helper: ggsInputHelper = ggsInputHelper.new()
	var new_input: InputEvent = input_helper.get_event_from_string(value)
	
	for event in InputMap.action_get_events(action):
		if _event_is_type(event):
			InputMap.action_erase_event(action, event)
	
	InputMap.action_add_event(action, new_input)


func _event_is_type(event: InputEvent) -> bool:
	match type:
		Type.KEYBOARD:
			return (event is InputEventKey) or (event is InputEventMouseButton)
		Type.GAMEPAD:
			return (event is InputEventJoypadButton) or (event is InputEventJoypadMotion)
		_:
			return false


### Properties

func set_action(value: String) -> void:
	action = value
	
	if is_added():
		save_plugin_data()


func set_type(value: Type) -> void:
	type = value
	
	if is_added():
		save_plugin_data()
