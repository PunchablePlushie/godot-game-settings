@tool
@icon("res://addons/ggs/plugin/assets/slider.svg")
extends ggsComponent

@onready var _Slider: HSlider = $Slider


func _ready() -> void:
	compatible_types = [TYPE_INT, TYPE_FLOAT]
	if Engine.is_editor_hint():
		return

	init_value()
	_Slider.value_changed.connect(_on_Slider_value_changed)
	_Slider.mouse_entered.connect(_on_Slider_mouse_entered)
	_Slider.focus_entered.connect(_on_Slider_focus_entered)


func init_value() -> void:
	value = GGS.get_value(setting)
	_Slider.set_value_no_signal(value)


func reset_setting() -> void:
	super()
	_Slider.value = value


func _on_Slider_value_changed(new_value: float) -> void:
	value = new_value

	if apply_on_changed:
		apply_setting()


func _on_Slider_mouse_entered() -> void:
	GGS.Audio.MouseEntered.play()

	if grab_focus_on_mouse_over:
		_Slider.grab_focus()


func _on_Slider_focus_entered() -> void:
	GGS.Audio.FocusEntered.play()
