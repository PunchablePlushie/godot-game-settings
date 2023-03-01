extends CheckButton

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var value: bool

@onready var section: String = setting.category
@onready var key: String = setting.name


func _ready() -> void:
	toggled.connect(_on_toggled)
	
	value = ggsSaveFile.new().get_key(section, key)
	set_pressed_no_signal(value)


func reset() -> void:
	value = setting.default
	set_pressed_no_signal(value)
	apply()


func apply() -> void:
	setting.current = value
	setting.apply(value)


func _on_toggled(btn_state: bool) -> void:
	value = btn_state
	if apply_on_change:
		apply()
