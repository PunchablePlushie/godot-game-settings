@tool
@icon("res://addons/ggs/plugin/assets/text_field.svg")
extends ggsComponent

@onready var _TextField: LineEdit = $TextField


func _ready() -> void:
	compatible_types = [TYPE_STRING]
	if Engine.is_editor_hint():
		return

	init_value()
	_TextField.text_submitted.connect(_on_TextField_text_submitted)


func init_value() -> void:
	value = GGS.get_value(setting)
	_TextField.text = value


func reset_setting() -> void:
	super()
	_TextField.text = value


func _on_TextField_text_submitted(submitted_text: String) -> void:
	value = submitted_text
	GGS.Audio.Interact.play()

	if apply_on_changed:
		apply_setting()
