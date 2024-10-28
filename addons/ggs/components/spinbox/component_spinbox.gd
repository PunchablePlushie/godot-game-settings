@tool
@icon("res://addons/ggs/plugin/assets/spinbox.svg")
extends ggsComponent

@onready var _SpinBox: SpinBox = $SpinBox
@onready var _Field: LineEdit = _SpinBox.get_line_edit()


func _ready() -> void:
	compatible_types = [TYPE_INT, TYPE_FLOAT]
	if Engine.is_editor_hint():
		return

	init_value()
	_SpinBox.value_changed.connect(_on_SpinBox_value_changed)
	_Field.context_menu_enabled = false


func init_value() -> void:
	value = GGS.get_value(setting)
	_SpinBox.set_value_no_signal(value)
	_Field.text = str(value)


func reset_setting() -> void:
	super()
	_SpinBox.value = value
	_Field.text = str(value)


func _on_SpinBox_value_changed(new_value: float) -> void:
	value = new_value
	GGS.Audio.Interact.play()

	if apply_on_changed:
		apply_setting()
