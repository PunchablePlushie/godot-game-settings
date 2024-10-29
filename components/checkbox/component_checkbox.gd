@tool
@icon("res://addons/ggs/plugin/assets/checkbox.svg")
extends ggsComponent

@onready var _Btn: Button = $Btn


func _ready() -> void:
	compatible_types = [TYPE_BOOL]
	if Engine.is_editor_hint():
		return

	init_value()
	_Btn.toggled.connect(_on_Btn_toggled)
	_Btn.mouse_entered.connect(_on_Btn_mouse_entered)
	_Btn.focus_entered.connect(_on_Btn_focus_entered)


func init_value() -> void:
	value = GGS.get_value(setting)
	_Btn.set_pressed_no_signal(value)


func reset_setting() -> void:
	super()
	_Btn.set_pressed_no_signal(value)


func _on_Btn_toggled(btn_state: bool) -> void:
	value = btn_state
	GGS.Audio.Interact.play()

	if apply_on_changed:
		apply_setting()


func _on_Btn_mouse_entered() -> void:
	GGS.Audio.MouseEntered.play()

	if grab_focus_on_mouse_over:
		_Btn.grab_focus()


func _on_Btn_focus_entered() -> void:
	GGS.Audio.FocusEntered.play()
