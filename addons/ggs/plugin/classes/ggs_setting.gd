@tool
extends Resource
class_name ggsSetting
## Base resource for a game setting.

## The default value of the setting.
var default: Variant = false: set = _set_default

## Section name used to save this setting.
var section: String = ""

## Key name used to save this setting.
var key: String: set = _set_key

## The value type this setting accepts when running [method apply].
## Also determines the type of [param default].[br]
## See [enum @GlobalScope.Variant.Type] for details.
var value_type: int = TYPE_BOOL: set = _set_value_type
# (Static Typing) Type.Variant is not used as it clutters the tooltip.

## Can be used to customize how [param default] is exported and shown in the
## inspector.[br]
## See [enum @GlobalScope.PropertyHint] for details.
var value_hint: int = PROPERTY_HINT_NONE
# (Static Typing) PropertyHint is not used as it clutters the tooltip.

## Hint string used to provide additional information for certain
## property hints.[br]
## See [enum @GlobalScope.PropertyHint] for details.
var value_hint_string: String = ""

## Any property in this array will be read-only if exported to the
## inspector via [method Object._get_property_list]. May not work with
## [annotation @GDScript.@export] annotations.

@export_storage var read_only_properties: PackedStringArray


func _get_property_list() -> Array:
	var properties: Array
	properties.append_array([
		{
			"name": "default",
			"type": value_type,
			"usage": get_property_usage("default"),
			"hint": value_hint,
			"hint_string": value_hint_string,
		},
		{
			"name": "section",
			"type": TYPE_STRING,
			"usage": get_property_usage("section"),
		},
		{
			"name": "key",
			"type": TYPE_STRING,
			"usage": get_property_usage("key"),
		},
		{
			"name": "Value Properties",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
			"hint_string": "value_",
		},
		{
			"name": "value_type",
			"type": TYPE_INT,
			"usage": get_property_usage("value_type"),
		},
		{
			"name": "value_hint",
			"type": TYPE_INT,
			"usage": get_property_usage("value_hint"),
		},
		{
			"name": "value_hint_string",
			"type": TYPE_STRING,
			"usage": get_property_usage("value_hint_string"),
		},
	])

	return properties


func _set_default(value: Variant) -> void:
	default = value

	if Engine.is_editor_hint() and not key.is_empty():
		GGS.set_value(self, value)


func _set_value_type(value: Variant.Type) -> void:
	value_type = value
	emit_changed()


func _set_key(value: String) -> void:
	key = value
	resource_name = value
	emit_changed()


## Returns the property usage of [param property]. Used to see if a property
## is read-only or not. See [member read_only_properties].
func get_property_usage(property: String) -> PropertyUsageFlags:
	var usage: PropertyUsageFlags = PROPERTY_USAGE_DEFAULT
	if read_only_properties.has(property):
		usage |= PROPERTY_USAGE_READ_ONLY

	return usage


# (Static Typing) No type hint for 'value' is provided to prevent error in
# child scripts that provide type hint when overriding this method.
## This method is called when GGS tries to apply the setting. In other words,
## it should contain the setting logic.
func apply(value) -> void:
	pass
