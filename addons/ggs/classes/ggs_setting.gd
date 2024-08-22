@tool
extends Resource
class_name ggsSetting
## Base resource for a game setting. Keeps track of the current and default
## values of the setting and provides its "address" when needed.

## The current value of the setting.
var current: Variant: set = _set_current, get = _get_current

## The default value of the setting.
var default: Variant

## The value type this setting accepts when running [method apply].
## Also determines the type of [param current] and [param default].[br]
## See [enum @GlobalScope.Variant.Type] for more details.
var value_type: int
# (Static Typing) Type.Variant is not used as it clutters the tooltip.

## The [enum @GlobalScope.PropertyHint] used for the value. Can be used to customize
## how [param current] and [param default] are exported and shown in the
## inspector.
var value_hint: int
# (Static Typing) PropertyHint is not used as it clutters the tooltip.

## Hint string used to provide additional information for certain
## property hints. See [enum @GlobalScope.PropertyHint] for details.
var value_hint_string: String

## Any property in this array will be read-only if exported to the
## inspector via [method Object._get_property_list]. May not work with 
## [annotation @GDScript.@export] annotations.
@export_storage var read_only_properties: PackedStringArray

## Name of section this setting will be saved under.
var section: String: get = get_section

## Name of the key this setting will be saved in.
var key: String: get = get_key


func _init(script_path: String = "") -> void:
	if not script_path.is_empty():
		var script = load(script_path)
		set_script(script)


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
		{
			"name": "Address",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
		},
		{
			"name": "section",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_EDITOR,
		},
		{
			"name": "key",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_EDITOR,
		},
	])
	
	return properties


func _get_property_usage(property: String) -> PropertyUsageFlags:
	var usage: PropertyUsageFlags = PROPERTY_USAGE_DEFAULT
	if read_only_properties.has(property):
		usage |= PROPERTY_USAGE_READ_ONLY
	
	return usage


#func _get(property: StringName) -> Variant:
	#if property == "resource_name":
		#resource_name = name
		#return resource_name
	#
	#return null


#region Setters & Getters
func get_section() -> String:
	var components: PackedStringArray = _get_path_components()
	
	if components.is_empty():
		return ""
	
	if components.size() == 1: # Resource file is not in a section folder
		return ""
	
	return components[0]


func get_key() -> String:
	var path_components: PackedStringArray = _get_path_components()
	
	if path_components.is_empty():
		return ""
	
	var file: String = path_components[path_components.size() - 1]
	
	var subsects: PackedStringArray = _get_subsections()
	var prefix: String
	for subsect: String in subsects:
		prefix += subsect + GGS.Pref.subsect_seperator
	
	return prefix + file.get_basename()


func _set_current(value: Variant) -> void:
	current = value
	
	var file: ConfigFile = ConfigFile.new()
	var path: String = GGS.Pref.path_file
	file.load(path)
	file.set_value(section, key, value)
	file.save(path)


func _get_current() -> Variant:
	var file: ConfigFile = ConfigFile.new()
	var path: String = GGS.Pref.path_file
	
	file.load(path)
	if file.has_section_key(section, key):
		return file.get_value(section, key)
	
	file.set_value(section, key, default)
	file.save(path)
	return default

#endregion


func _get_path_components() -> PackedStringArray:
	var settings: String = GGS.Pref.path_settings
	var base_path: String = resource_path.trim_prefix(settings)
	return base_path.split("/", false)


func _get_subsections() -> PackedStringArray:
	var components: PackedStringArray = _get_path_components()
	
	if components.size() == 2: # There are no subsections
		return []
	
	components.remove_at(0)
	components.remove_at(components.size() - 1)
	return components