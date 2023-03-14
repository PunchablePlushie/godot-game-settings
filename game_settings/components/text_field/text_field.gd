extends LineEdit

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var setting_value: String


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	
	_init_value()


func _init_value() -> void:
	setting_value = setting.current
	text = setting_value


func _on_text_submitted(submitted_text: String) -> void:
	setting_value = submitted_text
	if apply_on_change:
		apply_setting()


### Setting

func apply_setting() -> void:
	setting.current = setting_value
	setting.apply(setting_value)


func reset_setting() -> void:
	setting_value = setting.default
	text = setting_value
	apply_setting()
