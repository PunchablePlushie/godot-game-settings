@tool
@abstract
extends MarginContainer
class_name GGSComponent
## A components is a control/user interface node that allow the user to change the value of its assigned setting.

const _WARNING_NO_SETTING: String = "No setting is assigned."
const _WARNING_INVALID: String = "The assigned setting is invalid. Ensure that it's save on disc and is in the settings directory."
const _WARNING_EMPTY_KEY: String = "Setting key is empty and won't be saved to or loaded from the file."
const _WARNING_INCOMPATIBLE_SETTING: String = "The type of the assigned setting is not compatible with this component."

## The setting this component will handle. The setting type must be compatible with the component. See [member compatible_types].
@export var setting: GGSSetting: set = _set_setting

@export_group("Override", "override_")
## If enabled, plugin settings can be overriden for this specific component.
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "feature") var override_plugin_settings: bool = false: set = _set_override_plugin_settings
@export var override_apply_on_changed: bool = false
@export var override_grab_focus_on_mouseover: bool = false

## The current value of the setting associated with this component.
var value: Variant

## Value type(s) that are compatible with this component.
var compatible_types: Array[Variant.Type] = []


func _get_configuration_warnings() -> PackedStringArray:
	if setting == null:
		return [_WARNING_NO_SETTING]

	var warnings: PackedStringArray
	if (
		setting.resource_path.is_empty()
		or not setting.resource_path.begins_with(GGS.plugin_settings.settings_directory)
	):
		warnings.append(_WARNING_INVALID)

	if setting.key.is_empty():
		warnings.append(_WARNING_EMPTY_KEY)

	if (
		not compatible_types.is_empty()
		and not compatible_types.has(setting.type)
	):
		warnings.append(_WARNING_INCOMPATIBLE_SETTING)

	return warnings


func _set_setting(value: GGSSetting) -> void:
	# Disconnect signal of the previous setting
	if (
		setting != null
		and setting.changed.is_connected(_on_setting_resource_changed)
	):
		setting.changed.disconnect(_on_setting_resource_changed)

	setting = value
	update_configuration_warnings()
	if setting != null:
		setting.changed.connect(_on_setting_resource_changed)


func _set_override_plugin_settings(value: bool) -> void:
	override_plugin_settings = value
	if not override_plugin_settings:
		override_apply_on_changed = false
		override_grab_focus_on_mouseover = false


## Whether the setting should be applied on value change, depending on the override value.
func can_apply_on_changed() -> bool:
	if override_plugin_settings:
		return override_apply_on_changed
	else:
		return GGS.plugin_settings.components_apply_on_changed


## Whether the component should grab focus on mouseover, depending on the override value.
func can_grab_focus_on_mouseover() -> bool:
	if override_plugin_settings:
		return override_grab_focus_on_mouseover
	else:
		return GGS.plugin_settings.components_grab_focus_on_mouseover


## Saves the setting value to the save file and applies it to the game.[[br]
## An ApplyBtn calls this method to apply its associated settings.
func apply_setting() -> void:
	GGSSaveManager.save_setting_value(setting, value)
	GGS.setting_applied.emit(setting, value)
	setting.apply(value)


## Saves the default value of the setting to the save file and applies it to the game, effectively reseting it.[br]
## A ResetBtn calls this method to reset its associated settings.
func reset_setting() -> void:
	value = setting.default
	GGSSaveManager.save_setting_value(setting, value)
	GGS.setting_applied.emit(setting, value)
	setting.apply(value)


func _on_setting_resource_changed() -> void:
	update_configuration_warnings()
