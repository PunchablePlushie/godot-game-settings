@tool
extends ggsSetting

@export var action: String


func _init() -> void:
	name = "Keyboard Input"
	icon = preload("res://addons/ggs/assets/game_settings/input_kb.svg")
	desc = "Remap keyboard/mouse input for a specific input action."
	
	value_type = TYPE_STRING
	default = ""


func apply(value: String) -> void:
	var handler: ggsInputHandler = ggsInputHandler.new()
	var new_input: InputEvent = handler.parse_input_string(value)
	
	for event in InputMap.action_get_events(action):
		if (event is InputEventKey) or (event is InputEventMouseButton):
			InputMap.action_erase_event(action, event)
	
	InputMap.action_add_event(action, new_input)


### Action

func set_action(value: String) -> void:
	action = value
	
	if Engine.is_editor_hint():
		var data: ggsPluginData = ggsUtils.get_plugin_data()
		
		if data != null:
			data.save()
