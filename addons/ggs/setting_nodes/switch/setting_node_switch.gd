@tool
@icon("res://addons/ggs/assets/nodes/switch.svg")
extends ggsSettingNode

@onready var Btn: CheckButton = $Btn


func _init() -> void:
	compatible_types = [TYPE_BOOL]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if not validate_setting():
		return
	
	super()
	Btn.toggled.connect(_on_Btn_toggled)
	Btn.mouse_entered.connect(_on_Btn_mouse_entered)
	Btn.focus_entered.connect(_on_Btn_focus_entered)


func init_value() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)


func _on_Btn_toggled(toggled_on: bool) -> void:
	setting_value = toggled_on
	GGS.Audio.Interact.play()
	
	if apply_on_changed:
		apply_setting()


func reset_setting() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)


func _on_Btn_mouse_entered() -> void:
	GGS.Audio.MouseOver.play()
	
	if grab_focus_on_mouse_over:
		Btn.grab_focus()


func _on_Btn_focus_entered() -> void:
	GGS.Audio.Focus.play()
