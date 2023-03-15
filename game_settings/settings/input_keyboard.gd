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
	print(value)


### Action

func set_action(value: String) -> void:
	action = value
	
	if Engine.is_editor_hint():
		var data: ggsPluginData = ggsUtils.get_plugin_data()
		
		if data != null:
			data.save()
