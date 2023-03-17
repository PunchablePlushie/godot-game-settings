extends ggsUIComponent

enum Type {KEYBOARD, GAMEPAD}

@export_node_path("ConfirmationDialog") var icw: NodePath
@export var type: Type

@export_group("Keyboard")
@export var accept_mouse: bool = true
@export var accept_modifiers: bool = true

@onready var Btn: Button = $Btn
@onready var ICW: ConfirmationDialog = get_node(icw)
@onready var input_helper: ggsInputHelper = ggsInputHelper.new()


func _ready() -> void:
	super()
	Btn.pressed.connect(_on_Btn_pressed)
	ICW.input_selected.connect(_on_ICW_input_selected)


func init_value() -> void:
	super()
	var event: InputEvent = input_helper.get_event_from_string(setting_value)
	Btn.text = input_helper.get_event_as_text(event)


func _on_Btn_pressed() -> void:
	ICW.src = self
	ICW.type = type
	ICW.accept_mouse = accept_mouse
	ICW.accept_modifiers = accept_modifiers
	ICW.popup_centered()


func _on_ICW_input_selected(input: InputEvent) -> void:
	if ICW.src != self:
		return
	
	setting_value = input_helper.get_string_from_event(input)
	Btn.text = input_helper.get_event_as_text(input)
	
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	var event: InputEvent = input_helper.get_event_from_string(setting_value)
	Btn.text = input_helper.get_event_as_text(event)
