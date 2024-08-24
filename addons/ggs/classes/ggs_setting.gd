@tool
extends Resource
class_name ggsSetting
## Base resource for a game setting. Keeps track of the current and default
## values of the setting and provides its "address" when needed.

## The current value of the setting.
var current: Variant = false: set = _set_current, get = _get_current

## The default value of the setting.
var default: Variant = false

## The value type this setting accepts when running [method apply].
## Also determines the type of [param current] and [param default].[br]
## See [enum @GlobalScope.Variant.Type] for more details.
var value_type: int = TYPE_BOOL
# (Static Typing) Type.Variant is not used as it clutters the tooltip.

## The [enum @GlobalScope.PropertyHint] used for the value. Can be used to customize
## how [param current] and [param default] are exported and shown in the
## inspector.
var value_hint: int = PROPERTY_HINT_NONE
# (Static Typing) PropertyHint is not used as it clutters the tooltip.

## Hint string used to provide additional information for certain
## property hints. See [enum @GlobalScope.PropertyHint] for details.
var value_hint_string: String = ""

## Section name used to save this setting.
var section: String = ""

## Key name used to save this setting.
var key: String: set = _set_key

## Any property in this array will be read-only if exported to the
## inspector via [method Object._get_property_list]. May not work with 
## [annotation @GDScript.@export] annotations.
@export_storage var read_only_properties: PackedStringArray


func _get_property_list() -> Array:
	var properties: Array
	properties.append_array([
		{
			"name": "current",
			"type": value_type,
			"usage": _get_property_usage("current"),
			"hint": value_hint,
			"hint_string": value_hint_string,
		},
		{
			"name": "default",
			"type": value_type,
			"usage": _get_property_usage("default"),
			"hint": value_hint,
			"hint_string": value_hint_string,
		},
		{
			"name": "Setting Properties",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
		},
		{
			"name": "section",
			"type": TYPE_STRING,
			"usage": _get_property_usage("section"),
			"hint": PROPERTY_HINT_ENUM_SUGGESTION,
			"hint_string": ",".join(GGS.sections)
		},
		{
			"name": "key",
			"type": TYPE_STRING,
			"usage": _get_property_usage("key"),
		},
		{
			"name": "value_type",
			"type": TYPE_INT,
			"usage": _get_property_usage("value_type"),
		},
		{
			"name": "value_hint",
			"type": TYPE_INT,
			"usage": _get_property_usage("value_hint"),
		},
		{
			"name": "value_hint_string",
			"type": TYPE_STRING,
			"usage": _get_property_usage("value_hint_string"),
		},
	])
	
	return properties


func _set_current(value: Variant) -> void:
	current = value
	GGS.set_value(section, key, value)


func _get_current() -> Variant:
	GGS.file_reload()
	var value: Variant = GGS.get_value(section, key)
	
	if value == null:
		return default
	
	return value


func _set_key(value: String) -> void:
	key = value
	resource_name = value


func _get_property_usage(property: String) -> PropertyUsageFlags:
	var usage: PropertyUsageFlags = PROPERTY_USAGE_DEFAULT
	if read_only_properties.has(property):
		usage |= PROPERTY_USAGE_READ_ONLY
	
	return usage
