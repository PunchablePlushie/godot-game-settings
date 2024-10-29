@tool
@icon("res://addons/ggs/plugin/assets/base_node.svg")
extends MarginContainer
class_name ggsComponent
## Base class for a GGS UI component. Components are user interface nodes
## that allow the user to change the value of a specific setting.

const WARNING_NO_SETTING: String = "No setting is assigned."
const WARNING_INVALID: String = "The assigned setting is invalid. Make sure it's in the settings directory and is saved on disc."
const WARNING_EMPTY_KEY: String = "Setting key is empty and won't be saved to or loaded from the file."
const WARNING_INCOMPATIBLE_SETTING: String = "The value type of the assigned setting is not compatible with this component."

## The setting this component will handle. The setting's
## [member ggsSetting.value_type] must be in the [member compatible_types]
## of this component.
@export var setting: ggsSetting: set = _set_setting

## If true, the setting is applied when the component is interacted with.
## Otherwise, an ApplyBtn is needed.
@export var apply_on_changed: bool

## If true, the main control(s) of the component will grab focus when
## mouse enters it.
@export var grab_focus_on_mouse_over: bool = true

## The current value of the setting associated with this component.
var value: Variant

## [enum Variant.Type]s that this component accepts. The [member value_type]
## of any [ggsSetting] assigned to this component must be in this array.
var compatible_types: Array[Variant.Type] = []


func _get_configuration_warnings() -> PackedStringArray:
	if setting == null:
		return [WARNING_NO_SETTING]

	var warnings: PackedStringArray
	if (
		setting.resource_path.is_empty()
		or not setting.resource_path.begins_with(GGS.settings_dir)
	):
		warnings.append(WARNING_INVALID)

	if setting.key.is_empty():
		warnings.append(WARNING_EMPTY_KEY)

	if (
		not compatible_types.is_empty()
		and not compatible_types.has(setting.value_type)
	):
		warnings.append(WARNING_INCOMPATIBLE_SETTING)

	return warnings


func _set_setting(value: ggsSetting) -> void:
	if (
		setting != null
		and setting.changed.is_connected(_on_setting_resource_changed)
	):
		setting.changed.disconnect(_on_setting_resource_changed)

	setting = value
	update_configuration_warnings()

	if setting != null:
		setting.changed.connect(_on_setting_resource_changed)


## Saves the setting value to the save file and applies it to the game.
func apply_setting() -> void:
	GGS.set_value(setting, value)
	setting.apply(value)


## Saves the default value of the setting to the save file and applies it
## to the game, effectively reseting it.[br]
## [settingResetBtn] calls this method to reset the associated settings.
func reset_setting() -> void:
	GGS.set_value(setting, setting.default)
	setting.apply(value)


## Validates if the assigned [member setting] is valid and can be used with
## no issues.
func validate_setting() -> bool:
	if setting == null:
		printerr("GGS - Get Setting Value (%s) - No setting is assigned."%name)
		return false

	return true


func _on_setting_resource_changed() -> void:
	update_configuration_warnings()
