@tool
@icon("res://addons/ggs/plugin/assets/input.svg")
extends ggsComponent

enum State {NORMAL, LISTENING}
enum AcceptedTypes {
	KEYBOARD = 1 << 0,
	MOUSE = 1 << 1,
	JOYPAD_BUTTON = 1 << 2,
	JOYPAD_AXIS = 1 << 3,
}

const TEXT_ANIM: PackedStringArray = [".", "..", "...", "."]

## Types of input this component listens to.
@export_flags("Keyboard", "Mouse", "Joypad Button", "Joypad Axis")
var _accepted_types: int = 1

## Whether modifiers such as shift or ctrl should be accepted. Only relevant
## for keyboard and mouse events.
@export var _accept_modifiers: bool

@export_group("Icon")
## Whether the component should show use glyphs to show mouse and joypad
## events. Uses a glyph database.
@export var _use_glyph: bool

## The glyph database used to display inputs.
@export var _glyph: ggsGlyphDB

var _input_helper: ggsInputHelper = ggsInputHelper.new()
var _state: State = State.NORMAL: set = _set_state
var _new_event: InputEvent
var _tween: Tween
var _anim_frame: int: set = _set_anim_frame

@onready var _Btn: Button = $Btn
@onready var _ListenTime: Timer = $ListenTime
@onready var _AcceptDelay: Timer = $AcceptDelay


func _ready() -> void:
	compatible_types = [TYPE_ARRAY]
	if Engine.is_editor_hint():
		return

	_Btn.toggled.connect(_on_Btn_toggled)
	_Btn.mouse_entered.connect(_on_Btn_mouse_entered)
	_Btn.focus_entered.connect(_on_Btn_focus_entered)

	_ListenTime.timeout.connect(_on_ListenTime_timeout)
	_AcceptDelay.timeout.connect(_on_AcceptDelay_timeout)

	Input.joy_connection_changed.connect(_on_Input_joy_connection_changed)

	init_value()
	_ListenTime.wait_time = GGS.listen_time
	_AcceptDelay.wait_time = GGS.accept_delay


func _input(event: InputEvent) -> void:
	if _state != State.LISTENING:
		return

	if not _event_is_acceptable(event):
		return

	_new_event = event
	accept_event()
	_AcceptDelay.start()


func _set_state(value: State) -> void:
	_state = value

	match value:
		State.NORMAL:
			_Btn.set_pressed_no_signal(false)
			_tween.kill()
			_update_btn_display()
		State.LISTENING:
			_Btn.icon = null
			_tween = create_tween()
			_tween.bind_node(self)
			_tween.set_loops()
			_tween.tween_property(
					self,
					"_anim_frame",
					TEXT_ANIM.size() - 1,
					GGS.anim_speed
			).from(0)


func _set_anim_frame(value: int) -> void:
	_anim_frame = value
	_Btn.text = TEXT_ANIM[value]


func init_value() -> void:
	value = GGS.get_value(setting)
	_update_btn_display()


func reset_setting() -> void:
	super()
	_update_btn_display()


func _event_is_acceptable(event: InputEvent) -> bool:
	if (
		event is not InputEventKey
		and event is not InputEventMouseButton
		and event is not InputEventJoypadButton
		and event is not InputEventJoypadMotion
	):
		return false

	if not event.is_pressed():
		return false

	if event.is_echo():
		return false

	if (
		event is InputEventMouse
		and event.double_click
	):
		return false

	if (
		event is InputEventWithModifiers
		and not _accept_modifiers
		and (event.shift_pressed or event.ctrl_pressed or event.alt_pressed)
	):
		return false

	if (
		event is InputEventKey
		and not (_accepted_types & AcceptedTypes.KEYBOARD)
	):
		return false

	if (
		event is InputEventMouseButton
		and not (_accepted_types & AcceptedTypes.MOUSE)
	):
		return false

	if (
		event is InputEventJoypadButton
		and not (_accepted_types & AcceptedTypes.JOYPAD_BUTTON)
	):
		return false

	if (
		event is InputEventJoypadMotion
		and not (_accepted_types & AcceptedTypes.JOYPAD_AXIS)
	):
		return false

	return true



func _accepted_type_has_glyph() -> bool:
	return (
		_accepted_types & AcceptedTypes.MOUSE
		or _accepted_types & AcceptedTypes.JOYPAD_BUTTON
		or _accepted_types & AcceptedTypes.JOYPAD_AXIS
	)


func _update_btn_display() -> void:
	var event: InputEvent = _input_helper.deserialize_event(value)

	if (
		_use_glyph
		and _accepted_type_has_glyph()
	):
		_Btn.icon = _input_helper.event_get_glyph(event, _glyph)
		if _Btn.icon == null:
			_Btn.text = _input_helper.event_get_text(event)
		else:
			_Btn.text = ""

		return

	_Btn.icon = null
	_Btn.text = _input_helper.event_get_text(event)


func _on_Btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GGS.Audio.Interact.play()
		_state = State.LISTENING
		_ListenTime.start()


func _on_ListenTime_timeout() -> void:
	_state = State.NORMAL


func _on_AcceptDelay_timeout() -> void:
	_state = State.NORMAL

	value = _input_helper.serialize_event(_new_event)
	if apply_on_changed:
		apply_setting()

	_new_event = null
	_update_btn_display()
	GGS.Audio.InputAccepted.play()


func _on_Btn_mouse_entered() -> void:
	GGS.Audio.MouseEntered.play()
	if grab_focus_on_mouse_over:
		_Btn.grab_focus()


func _on_Btn_focus_entered() -> void:
	GGS.Audio.FocusEntered.play()


func _on_Input_joy_connection_changed(_device: int, _connected: bool) -> void:
	_update_btn_display()
