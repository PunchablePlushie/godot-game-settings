extends OptionButton

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var setting_value: int

@onready var save_section: String = setting.category
@onready var save_key: String = setting.name


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	
	_init_value()


func _init_value() -> void:
	setting_value = ggsSaveFile.new().get_key(save_section, save_key)
	select(setting_value)


func _on_item_selected(item_index: int) -> void:
	setting_value = item_index
	if apply_on_change:
		apply_setting()


### Setting

func apply_setting() -> void:
	setting.current = setting_value
	setting.apply(setting_value)


func reset_setting() -> void:
	setting_value = setting.default
	select(setting_value)
	apply_setting()
