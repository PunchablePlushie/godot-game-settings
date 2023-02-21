extends CheckButton

@export var setting: ggsSetting
@export var apply_on_change: bool = GGS.data.apply_on_change_default

var value: bool


func _ready() -> void:
	value = setting.current
	button_pressed = setting.current
	
	toggled.connect(_on_toggled)


func reset() -> void:
	value = setting.default
	setting.current = value
	
	button_pressed = value


func apply() -> void:
	setting.current = value
	setting.apply(value)


func _on_toggled(btn_state: bool) -> void:
	value = btn_state
	if apply_on_change:
		apply()
