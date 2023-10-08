@tool
extends ggsUIComponent

@onready var Btn: Button = $Btn


func _ready() -> void:
	compatible_types = [TYPE_BOOL]
	if Engine.is_editor_hint():
		return
	
	super()
	Btn.toggled.connect(_on_Btn_toggled)
	Btn.mouse_entered.connect(_on_Btn_mouse_entered)
	Btn.focus_entered.connect(_on_Btn_focus_entered)


func init_value() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)


func _on_Btn_toggled(btn_state: bool) -> void:
	setting_value = btn_state
	_play_interact_sfx()
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)


### SFX

func _play_interact_sfx() -> void:
	if sfx_interact != null:
		sfx_interact.play()


func _on_Btn_mouse_entered() -> void:
	if sfx_mouse_over != null:
		sfx_mouse_over.play()
	
	if grab_focus_on_mouse_over:
		Btn.grab_focus()


func _on_Btn_focus_entered() -> void:
	if sfx_focus != null:
		sfx_focus.play()
