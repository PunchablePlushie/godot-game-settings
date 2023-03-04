extends Button

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var setting_value: bool

@onready var save_section: String = setting.category
@onready var save_key: String = setting.name


func _ready() -> void:
	toggled.connect(_on_toggled)
	
	_init_value()


func _init_value() -> void:
	setting_value = ggsSaveFile.new().get_key(save_section, save_key)
	set_pressed_no_signal(setting_value)


func _on_toggled(btn_state: bool) -> void:
	setting_value = btn_state
	if apply_on_change:
		apply_setting()


### Setting

func apply_setting() -> void:
	setting.current = setting_value
	setting.apply(setting_value)


func reset_setting() -> void:
	setting_value = setting.default
	set_pressed_no_signal(setting_value)
	apply_setting()
