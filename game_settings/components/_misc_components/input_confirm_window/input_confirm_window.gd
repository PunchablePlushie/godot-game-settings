extends ConfirmationDialog
signal input_selected(chosen_input: InputEvent)

enum Type {KEYBOARD, GAMEPAD}

@export var listening_wait_time: float = 0.35
@export var listening_max_time: float = 5
@export var show_progress_bar: bool = true
@export_group("Text")
@export var btn_listening: String = ". . ."
@export var title_listening: String = "Listening for Input"
@export var title_confirm: String = "Confirm Input"
@export var timeout_text: String = "Timed Out"
@export var already_exists_msg: String = "Input already exists ({action})"

var chosen_input: InputEvent
var src: ggsUIComponent
var type: Type
var accept_mouse: bool
var accept_modifiers: bool
var use_icons: bool

@onready var OkBtn: Button = get_ok_button()
@onready var CancelBtn: Button = get_cancel_button()
@onready var ListenBtn: Button = $MainCtnr/ListenBtn
@onready var ListenTimer: Timer = $ListenTimer
@onready var MaxListenTimer: Timer = $MaxListenTimer
@onready var ListenProgress: ProgressBar = $MainCtnr/ListenProgress
@onready var AlreadyExistsLabel: Label = $MainCtnr/AlreadyExistsLabel

@onready var input_helper: ggsInputHelper = ggsInputHelper.new()


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	confirmed.connect(_on_confirmed)
	
	ListenBtn.pressed.connect(_on_ListenBtn_pressed)
	ListenTimer.timeout.connect(_on_ListenTimer_timeout)
	MaxListenTimer.timeout.connect(_on_MaxListenTimer_timeout)
	
	ListenBtn.focus_neighbor_bottom = OkBtn.get_path()
	OkBtn.focus_neighbor_top = ListenBtn.get_path()
	CancelBtn.focus_neighbor_top = ListenBtn.get_path()
	
	ListenTimer.wait_time = listening_wait_time
	MaxListenTimer.wait_time = listening_max_time


func _process(_delta: float) -> void:
	ListenProgress.value = ListenTimer.time_left / ListenTimer.wait_time


func _input(event: InputEvent) -> void:
	if not _event_is_valid(event):
		return
	
	_set_btn_text_or_icon(event)
	
	var input_already_exists: Array = input_helper.input_already_exists(event, src.setting.action)
	if input_already_exists[0]:
		AlreadyExistsLabel.text = already_exists_msg.format({"action": input_already_exists[1].capitalize()})
		
		ListenProgress.hide()
		AlreadyExistsLabel.show()
		ListenTimer.stop()
		MaxListenTimer.start()
		return
	
	ListenProgress.show()
	AlreadyExistsLabel.hide()
	ListenTimer.start()
	MaxListenTimer.start()
	
	chosen_input = event


func _event_is_valid(event: InputEvent) -> bool:
	var type_is_valid: bool
	if type == Type.KEYBOARD:
		if accept_mouse:
			type_is_valid = (
				event is InputEventKey or
				event is InputEventMouseButton
			)
		else:
			type_is_valid = (event is InputEventKey)
	else:
		type_is_valid = (
			event is InputEventJoypadButton or
			event is InputEventJoypadMotion
		)
	
	var has_modifier: bool = false
	if event is InputEventWithModifiers:
		has_modifier = (event.shift_pressed or event.alt_pressed or event.ctrl_pressed)
	
	var is_double_click: bool = false
	var mouse_button_is_valid: bool = true
	if event is InputEventMouseButton:
		is_double_click = event.double_click
		mouse_button_is_valid = (event.button_index >= 0 and event.button_index <= 9)
	
	var is_valid: bool
	if accept_modifiers:
		is_valid = (
		type_is_valid and
		event.is_pressed() and
		not event.is_echo() and
		not is_double_click and
		mouse_button_is_valid)
	else:
		is_valid = (
		type_is_valid and
		event.is_pressed() and
		not event.is_echo() and
		not is_double_click and
		mouse_button_is_valid and 
		not has_modifier)
	
	return is_valid


### Input Listening

func _set_btn_text_or_icon(event: InputEvent) -> void:
	if use_icons and type == Type.GAMEPAD:
		ListenBtn.icon = input_helper.get_event_as_icon(event, src.icon_db)
		
		if ListenBtn.icon == null:
			ListenBtn.text = input_helper.get_event_as_text(event)
		else:
			ListenBtn.text = ""
		return
	
	ListenBtn.icon = null
	ListenBtn.text = input_helper.get_event_as_text(event)


func _start_listening() -> void:
	ListenBtn.text = btn_listening
	ListenBtn.icon = null
	title = title_listening
	
	OkBtn.release_focus()
	OkBtn.disabled = true
	OkBtn.focus_mode = Control.FOCUS_NONE
	
	ListenBtn.release_focus()
	ListenBtn.disabled = true
	ListenBtn.focus_mode = Control.FOCUS_NONE
	
	CancelBtn.release_focus()
	
	if show_progress_bar:
		ListenProgress.show()
	
	set_process_input(true)
	set_process(true)
	MaxListenTimer.start()


func _stop_listening(timed_out: bool = false) -> void:
	title = title_confirm
	
	if not timed_out:
		OkBtn.focus_mode = Control.FOCUS_ALL
		OkBtn.disabled = false
	
	ListenBtn.focus_mode = Control.FOCUS_ALL
	ListenBtn.disabled = false
	ListenBtn.grab_focus()
	
	if timed_out:
		ListenBtn.text = timeout_text
		ListenBtn.icon = null
		CancelBtn.grab_focus()
	
	ListenProgress.hide()
	AlreadyExistsLabel.hide()
	
	set_process_input(false)
	set_process(false)
	MaxListenTimer.stop()


func _on_ListenBtn_pressed() -> void:
	_start_listening()


func _on_ListenTimer_timeout() -> void:
	_stop_listening()


func _on_MaxListenTimer_timeout() -> void:
	_stop_listening(true)


### Window

func _on_visibility_changed() -> void:
	if visible:
		OkBtn.release_focus()
		chosen_input = null
		_start_listening()


func _on_confirmed() -> void:
	input_selected.emit(chosen_input)
