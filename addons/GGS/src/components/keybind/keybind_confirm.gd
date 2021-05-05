extends PopupPanel
signal confirmed(event)

enum Type {Keyboard, Gamepad}
var type: int
var source: Object
onready var Message: Label = $Mrg/Message


func _ready() -> void:
	# Setup popup
	get_tree().paused = true
	Message.text = ggsManager.ggs_data["keybind_confirm_text"]


func _input(event: InputEvent) -> void:
	# Only accept the correct type
	match type:
		Type.Keyboard:
			if not event is InputEventKey:
				return
		Type.Gamepad:
			if not event is InputEventJoypadButton:
				return
	
	# Only continue when the key is being pressed
	if not event.pressed:
		return
	
	# Check if the key is already assigned. Ignores UI actions.
	var actions: Array = _get_non_ui_actions(InputMap.get_actions())
	for action in actions:
		if InputMap.action_has_event(action, event):
			Message.text = ggsManager.ggs_data["keybind_assigned_text"]
			return
	
	# Confirm the new key
	emit_signal("confirmed", event)
	get_tree().set_input_as_handled()
	get_tree().paused = false
	source.grab_focus()
	queue_free()


func _get_non_ui_actions(actions: Array) -> Array:
	var result: Array = []
	for action in actions:
		if not action.begins_with("ui_"):
			result.append(action)
	return result
