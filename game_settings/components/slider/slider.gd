extends HSlider

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

@onready var section: String = setting.category
@onready var key: String = setting.name


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	
	set_value_no_signal(ggsSaveFile.new().get_key(section, key))


func _on_value_changed(_new_value: float) -> void:
	if apply_on_change:
		apply()


### Setting

func apply() -> void:
	setting.current = value
	setting.apply(value)


func reset() -> void:
	value = setting.default
