extends ggsUIComponent

@onready var Btn: Button = $Btn


func _ready() -> void:
	super()
	Btn.toggled.connect(_on_Btn_toggled)


func init_value() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)


func _on_Btn_toggled(btn_state: bool) -> void:
	setting_value = btn_state
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)
