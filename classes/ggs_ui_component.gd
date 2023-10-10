@tool
extends MarginContainer
class_name ggsUIComponent

const WARNING_NO_SETTING: String = "No setting is assigned."
const WARNING_DELETED_SETTING: String = "The assigned setting was deleted or is invalid."
const WARNING_SETTING_NOT_IN_DIR: String = "The assigned setting is not in the settings directory."
const WARNING_INCOMPATIBLE_SETTING: String = "The value type of the assigned setting is not compatible with this component."

@export_category("GGS UI Component")
@export var setting: ggsSetting: set = set_setting
@export var apply_on_change: bool
@export var grab_focus_on_mouse_over: bool

var setting_value: Variant
var compatible_types: Array[Variant.Type] = []


func _ready() -> void:
	init_value()


func _get_configuration_warnings() -> PackedStringArray:
	if setting == null:
		return PackedStringArray([WARNING_NO_SETTING])
	
	if setting.resource_path.is_empty():
		return PackedStringArray([WARNING_DELETED_SETTING])
	
	if not setting.resource_path.begins_with(ggsUtils.get_plugin_data().dir_settings):
		return PackedStringArray([WARNING_SETTING_NOT_IN_DIR])
	
	if (
		not compatible_types.is_empty() and
		not compatible_types.has(setting.value_type)
	):
		return PackedStringArray([WARNING_INCOMPATIBLE_SETTING])
	
	
	return PackedStringArray()


func set_setting(value: ggsSetting) -> void:
	setting = value
	update_configuration_warnings()


func init_value() -> void:
	if setting != null:
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
