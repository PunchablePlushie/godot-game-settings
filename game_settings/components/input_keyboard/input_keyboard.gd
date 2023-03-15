extends ggsUIComponent

@export_node_path("ConfirmationDialog") var icw: NodePath

@onready var Btn: Button = $Btn
@onready var ICW: ConfirmationDialog = get_node(icw)
@onready var input_handler: ggsInputHandler = ggsInputHandler.new()


func _ready() -> void:
	super()
	Btn.pressed.connect(_on_Btn_pressed)
	ICW.input_selected.connect(_on_ICW_input_selected)


func init_value() -> void:
	super()
	var event: InputEvent = input_handler.parse_input_string(setting_value)
	_set_btn_text(event)


func _set_btn_text(event: InputEvent) -> void:
	if event is InputEventKey:
		Btn.text = OS.get_keycode_string(event.get_physical_keycode_with_modifiers())
	
	if event is InputEventMouseButton:
		Btn.text = input_handler.get_mouse_event_string_abbr(event)


func _on_Btn_pressed() -> void:
	ICW.src = self
	ICW.popup_centered()


func _on_ICW_input_selected(input: InputEvent) -> void:
	setting_value = input_handler.get_input_string_from_event(input)
	_set_btn_text(input)
	
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	var event: InputEvent = input_handler.parse_input_string(setting_value)
	_set_btn_text(event)
