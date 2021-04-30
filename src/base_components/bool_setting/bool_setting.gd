extends BaseComponent
class_name ggsBool

onready var setting: Node = GameSettings.find_node(setting_node)
onready var button: CheckButton = $CheckButton


func _ready() -> void:
	if starts_with_focus:
		button.grab_focus()

	button.pressed = GameSettings.get_setting(setting.section, setting.key)
	button.connect("toggled", self, "_on_CheckButton_toggled")
	_update_value(button.pressed)


func on_interaction() -> void:
	pass


func _update_value(button_state: bool) -> void:
	GameSettings.set_setting(setting.section, setting.key, button_state)
	on_interaction()


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	_update_value(button_pressed)
