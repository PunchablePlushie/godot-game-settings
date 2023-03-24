extends ggsUIComponent

enum Type {KEYBOARD, GAMEPAD}

@export_node_path("ConfirmationDialog") var icw: NodePath
@export var type: Type

@export_group("Keyboard")
@export var accept_mouse: bool = true
@export var accept_modifiers: bool = true

@export_group("Gamepad")
@export var use_icons: bool
@export var icon_db: ggsGPIconDB

@onready var Btn: Button = $Btn
@onready var ICW: ConfirmationDialog = get_node(icw)
@onready var input_helper: ggsInputHelper = ggsInputHelper.new()


func _ready() -> void:
	super()
	Btn.pressed.connect(_on_Btn_pressed)
	ICW.input_selected.connect(_on_ICW_input_selected)
	Input.joy_connection_changed.connect(_on_Input_joy_connection_changed)


func init_value() -> void:
	super()
	var event: InputEvent = input_helper.get_event_from_string(setting_value)
	_set_btn_text_or_icon(event)


func _on_Btn_pressed() -> void:
	ICW.src = self
	ICW.type = type
	ICW.accept_mouse = accept_mouse
	ICW.accept_modifiers = accept_modifiers
	ICW.use_icons = use_icons
	ICW.popup_centered()


func _on_ICW_input_selected(input: InputEvent) -> void:
	if ICW.src != self:
		return
	
	setting_value = input_helper.get_string_from_event(input)
	_set_btn_text_or_icon(input)
	
	if apply_on_change:
		apply_setting()


### Button Text or Icon

func _set_btn_text_or_icon(event: InputEvent) -> void:
	if use_icons and type == Type.GAMEPAD:
		Btn.icon = input_helper.get_event_as_icon(event, icon_db)
		
		if Btn.icon == null:
			Btn.text = input_helper.get_event_as_text(event)
		else:
			Btn.text = ""
		return
	
	Btn.icon = null
	Btn.text = input_helper.get_event_as_text(event)


func _on_Input_joy_connection_changed(_device: int, _connected: bool) -> void:
	var event: InputEvent = input_helper.get_event_from_string(setting_value)
	_set_btn_text_or_icon(event)


### Setting

func reset_setting() -> void:
	super()
	var event: InputEvent = input_helper.get_event_from_string(setting_value)
	_set_btn_text_or_icon(event)
