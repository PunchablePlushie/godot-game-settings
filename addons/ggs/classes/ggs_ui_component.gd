extends MarginContainer
class_name ggsUIComponent

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var setting_value: Variant


func _ready() -> void:
	init_value()


func init_value() -> void:
	setting_value = setting.current


func apply_setting() -> void:
	setting.current = setting_value #!1
	setting.apply(setting_value)


func reset_setting() -> void:
	setting_value = setting.default
	apply_setting()


#1 Note that during runtime, the setting resource itself is not actually changed
 # since all resources are read-only during runtime. However, the setter
 # function (set_setting) of the resource is still executed.
 # View ggs_setting.gd/set_setting() for more info.
