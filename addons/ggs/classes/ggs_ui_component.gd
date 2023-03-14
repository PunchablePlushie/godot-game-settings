extends MarginContainer
class_name ggsUIComponent

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var setting_value: bool


func _ready() -> void:
	init_value()


func init_value() -> void:
	setting_value = setting.current


func apply_setting() -> void:
	setting.current = setting_value
	setting.apply(setting_value)


func reset_setting() -> void:
	setting_value = setting.default
	apply_setting()
