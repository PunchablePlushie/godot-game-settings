@tool
extends ggsUIComponent

@export var ICW: ConfirmationDialog
@export var accept_modifiers: bool
@export var accept_mouse: bool
@export var accept_axis: bool

@export_group("Icon")
@export var use_icons: bool
@export var icon_db: ggsIconDB

var type: ggsInputHelper.InputType = ggsInputHelper.InputType.INVALID
var input_helper: ggsInputHelper = ggsInputHelper.new()

@onready var Btn: Button = $Btn


func _ready() -> void:
	compatible_types = [TYPE_ARRAY]
	if Engine.is_editor_hint():
		return
	
	super()
	Btn.pressed.connect(_on_Btn_pressed)
	ICW.input_selected.connect(_on_ICW_input_selected)
	Input.joy_connection_changed.connect(_on_Input_joy_connection_changed)
	
	Btn.mouse_entered.connect(_on_Btn_mouse_entered)
	Btn.focus_entered.connect(_on_Btn_focus_entered)


func init_value() -> void:
	super()
	var event: InputEvent = input_helper.create_event_from_type(setting_value[0])
	
	type = input_helper.get_event_type(event)
	
	input_helper.set_event_id(event, setting_value[1])
	_set_btn_text_or_icon(event)


func _on_Btn_pressed() -> void:
	ICW.src = self
	ICW.type = type
	ICW.accept_mouse = accept_mouse
	ICW.accept_modifiers = accept_modifiers
	ICW.accept_axis = accept_axis
	ICW.use_icons = use_icons
	ICW.popup_centered()
	
	GGS.play_sfx(GGS.SFX.FOCUS)


func _on_ICW_input_selected(event: InputEvent) -> void:
	if ICW.src != self:
		return
	
	setting_value = [input_helper.get_event_type(event), input_helper.get_event_id(event)]
	_set_btn_text_or_icon(event)
	
	if apply_on_change:
		apply_setting()


### Button Text or Icon

func _set_btn_text_or_icon(event: InputEvent) -> void:
	if (
		use_icons and
		(type == ggsInputHelper.InputType.MOUSE or
		type == ggsInputHelper.InputType.GP_BTN or
		type == ggsInputHelper.InputType.GP_MOTION)
	):
		Btn.icon = input_helper.get_event_as_icon(event, icon_db)
		
		if Btn.icon == null:
			Btn.text = input_helper.get_event_as_text(event)
		else:
			Btn.text = ""
		
		return
	
	Btn.icon = null
	Btn.text = input_helper.get_event_as_text(event)


func _on_Input_joy_connection_changed(_device: int, _connected: bool) -> void:
	var event: InputEvent = input_helper.create_event_from_type(setting_value[0])
	input_helper.set_event_id(event, setting_value[1])
	_set_btn_text_or_icon(event)


### Setting

func reset_setting() -> void:
	super()
	var event: InputEvent = input_helper.create_event_from_type(setting_value[0])
	input_helper.set_event_id(event, setting_value[1])
	_set_btn_text_or_icon(event)


### SFX

func _on_Btn_mouse_entered() -> void:
	GGS.play_sfx(GGS.SFX.MOUSE_OVER)
	
	if grab_focus_on_mouse_over:
		Btn.grab_focus()


func _on_Btn_focus_entered() -> void:
	GGS.play_sfx(GGS.SFX.FOCUS)
