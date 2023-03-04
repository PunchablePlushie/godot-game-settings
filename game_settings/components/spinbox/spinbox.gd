extends SpinBox

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var setting_value

@onready var save_section: String = setting.category
@onready var save_key: String = setting.name

@onready var Field: LineEdit = get_line_edit()


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	
	_init_value()


func _init_value() -> void:
	setting_value = ggsSaveFile.new().get_key(save_section, save_key)
	set_value_no_signal(setting_value)
	Field.text = str(setting_value)


func _on_value_changed(new_value: float) -> void:
	setting_value = new_value
	
	if apply_on_change:
		apply_setting()


### Setting

func apply_setting() -> void:
	setting.current = setting_value
	setting.apply(setting_value)


func reset_setting() -> void:
	setting_value = setting.default
	value = setting_value
	Field.text = str(setting_value)
