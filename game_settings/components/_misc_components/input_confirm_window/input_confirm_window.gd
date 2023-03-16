extends ConfirmationDialog
signal input_selected(chosen_input: InputEvent)

enum Type {KEYBOARD, GAMEPAD}

@export var listening_wait_time: float = 0.5
@export var show_progress_bar: bool = true
@export_group("Text")
@export var btn_listening: String = ". . ."
@export var title_listening: String = "Listening for Input"
@export var title_confirm: String = "Confirm Input"
@export var already_exists_msg: String = "Input already exists ({action})"

var chosen_input: InputEvent
var src: ggsUIComponent
var accept_mouse: bool
var type: Type

@onready var ListenBtn: Button = $MainCtnr/ListenBtn
@onready var OkBtn: Button = get_ok_button()
@onready var CancelBtn: Button = get_cancel_button()
@onready var ListenTimer: Timer = $ListenTimer
@onready var ListenProgress: ProgressBar = $MainCtnr/ListenProgress
@onready var AlreadyExistsLabel: Label = $MainCtnr/AlreadyExistsLabel

@onready var input_handler: ggsInputHandler = ggsInputHandler.new()


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	confirmed.connect(_on_confirmed)
	
	ListenBtn.pressed.connect(_on_ListenBtn_pressed)
	ListenTimer.timeout.connect(_on_ListenTimer_timeout)
	
	ListenBtn.focus_neighbor_bottom = OkBtn.get_path()
	OkBtn.focus_neighbor_top = ListenBtn.get_path()
	CancelBtn.focus_neighbor_top = ListenBtn.get_path()
	
	ListenTimer.wait_time = listening_wait_time


func _process(_delta: float) -> void:
	ListenProgress.value = ListenTimer.time_left / ListenTimer.wait_time


func _input(event: InputEvent) -> void:
	if not _event_is_valid(event):
		return
	
	if event is InputEventKey:
		ListenBtn.text = OS.get_keycode_string(event.get_physical_keycode_with_modifiers())
	
	if event is InputEventMouseButton:
		ListenBtn.text = input_handler.get_mouse_event_string_abbr(event)
	
	var input_already_exists: Array = input_handler.input_already_exists(event, src.setting.action)
	if input_already_exists[0]:
		AlreadyExistsLabel.text = already_exists_msg.format({"action": input_already_exists[1].capitalize()})
		
		ListenProgress.hide()
		AlreadyExistsLabel.show()
		ListenTimer.stop()
		return
	
	ListenProgress.show()
	AlreadyExistsLabel.hide()
	ListenTimer.start()
	
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
	
	var double_click: bool = false
	if event is InputEventMouseButton:
		double_click = event.double_click
	
	return (
		type_is_valid and
		event.is_pressed() and
		not event.is_echo() and
		not double_click
	)


### Input Listening

func _on_ListenBtn_pressed() -> void:
	_start_listening()


func _start_listening() -> void:
	ListenBtn.text = btn_listening
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


func _stop_listening() -> void:
	title = title_confirm
	
	OkBtn.focus_mode = Control.FOCUS_ALL
	OkBtn.disabled = false
	
	ListenBtn.focus_mode = Control.FOCUS_ALL
	ListenBtn.disabled = false
	ListenBtn.grab_focus()
	
	ListenProgress.hide()
	
	set_process_input(false)
	set_process(false)


func _on_ListenTimer_timeout() -> void:
	_stop_listening()


### Window

func _on_visibility_changed() -> void:
	if visible:
		OkBtn.release_focus()
		chosen_input = null
		_start_listening()


func _on_confirmed() -> void:
	input_selected.emit(chosen_input)
