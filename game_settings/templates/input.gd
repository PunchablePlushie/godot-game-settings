@tool
extends ggsSetting

enum Type {KEYBOARD, GAMEPAD}

@export var action: String
@export var type: Type


func _init() -> void:
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
