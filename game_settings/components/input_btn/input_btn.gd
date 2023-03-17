extends ggsUIComponent

enum Type {KEYBOARD, GAMEPAD}

@export_node_path("ConfirmationDialog") var icw: NodePath
@export var type: Type

@export_group("Keyboard")
@export var accept_mouse: bool = true
@export var accept_modifiers: bool = true

@onready var Btn: Button = $Btn
@onready var ICW: ConfirmationDialog = get_node(icw)
@onready var input_handler: ggsInputHelper = ggsInputHelper.new()


func _ready() -> void:
	super()
	Btn.pressed.connect(_on_Btn_pressed)
	ICW.input_selected.connect(_on_ICW_input_selected)


func init_value() -> void:
	super()
	var event: InputEvent = input_handler.get_event_from_string(setting_value)
	_set_btn_text(event)


func _on_Btn_pressed() -> void:
	ICW.src = self
	ICW.type = type
	ICW.accept_mouse = accept_mouse
	ICW.accept_modifiers = accept_modifiers
	ICW.popup_centered()


func _on_ICW_input_selected(input: InputEvent) -> void:
	if ICW.src != self:
		return
	
	setting_value = input_handler.get_string_from_event(input)
	_set_btn_text(input)
	
	if apply_on_change:
		apply_setting()


### Button Text

func _set_btn_text(event: InputEvent) -> void:
	match type:
		Type.KEYBOARD:
			_set_btn_text_with_kb_event(event)
		Type.GAMEPAD:
			_set_btn_text_with_gp_event(event)


func _set_btn_text_with_kb_event(event: InputEvent) -> void:
	if event is InputEventKey:
		Btn.text = OS.get_keycode_string(event.get_physical_keycode_with_modifiers())
	
	if event is InputEventMouseButton:
		Btn.text = input_handler.get_mouse_event_string_abbr(event)


func _set_btn_text_with_gp_event(event: InputEvent) -> void:
	Btn.text = input_handler.get_gp_event_string(event)


### Setting

func reset_setting() -> void:
	super()
	var event: InputEvent = input_handler.get_event_from_string(setting_value)
	_set_btn_text(event)
