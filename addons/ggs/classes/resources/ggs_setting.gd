@tool
extends Resource
class_name ggsSetting

var current: Variant: set = set_current, get = get_current
var default: Variant: set = set_default
var name: String
var category: String
var value_type: Variant.Type
var value_hint: PropertyHint
var value_hint_string: String


func _init() -> void:
#	update_name()
#	update_category()
	pass


func _get_property_list() -> Array:
	var usage: PropertyUsageFlags =  PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
	var enum_string_types: String = ggsUtils.get_enum_string("Variant.Type")
	var enum_string_property_hints: String = ggsUtils.get_enum_string("PropertyHint")

	var properties: Array
	properties.append_array([
		{"name": "Setting (%s)"%name, "type": TYPE_NIL, "usage": PROPERTY_USAGE_CATEGORY},
		{"name": "current", "type": value_type, "usage": PROPERTY_USAGE_DEFAULT, "hint": value_hint, "hint_string": value_hint_string},
		{"name": "default", "type": value_type, "usage": PROPERTY_USAGE_DEFAULT, "hint": value_hint, "hint_string": value_hint_string},
		{"name": "Internal", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP},
		{"name": "name", "type": TYPE_STRING, "usage": usage},
		{"name": "category", "type": TYPE_STRING, "usage": usage},
		{"name": "value_type", "type": TYPE_INT, "usage": usage, "hint": PROPERTY_HINT_ENUM, "hint_string": enum_string_types},
		{"name": "value_hint", "type": TYPE_INT, "usage": usage, "hint": PROPERTY_HINT_ENUM, "hint_string": enum_string_property_hints},
		{"name": "value_hint_string", "type": TYPE_STRING, "usage": usage},
	])

	return properties


func set_current(value: Variant) -> void:
	current = value
	ggsSaveFile.new().set_key(category, resource_name, value)

# res://game_settings/settings/audio/-master/mute_state/mute_state.tres
# name = master_mute_state == resource_path.trim_prefix().find("/")

func update_category() -> void:
	var dir_settings: String = ggsUtils.get_plugin_data().dir_settings
	
	if not resource_path.begins_with(dir_settings):
		category = ""
		return
	
	category = resource_path.trim_prefix(dir_settings).get_slice("/", 0)


func update_name() -> void:
	var dir_settings: String = ggsUtils.get_plugin_data().dir_settings
	
	if not resource_path.begins_with(dir_settings):
		name = ""
		return
	
	var path: String = resource_path.trim_prefix(dir_settings + "/")
	var slash_idx: int = path.find("/")
	path = path.erase(0, slash_idx)
	path = path.trim_prefix("/").replace("-", "").replace("/", "_").trim_suffix(".tres")
	name = path


func get_current() -> Variant:
	var save_file: ggsSaveFile = ggsSaveFile.new()
	if save_file.has_section_key(category, resource_name):
		return save_file.get_value(category, resource_name)
	else:
		save_file.set_key(category, resource_name, default)
		return default


func set_default(value: Variant) -> void:
	default = value
	
	if Engine.is_editor_hint():
		var plugin_data: ggsPluginData = ggsUtils.get_plugin_data()
		
		if plugin_data != null:
			plugin_data.save()


func set_name(value: String) -> void:
	resource_name = value
	resource_name = value
	notify_property_list_changed()


### Public Methods

func delete() -> void:
	set_script(load("res://addons/ggs/classes/resources/ggs_setting.gd"))
	resource_name = "[Deleted Setting]"


func save_plugin_data() -> void:
	if not Engine.is_editor_hint():
		return
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	if data != null:
		data.save()


func is_added() -> bool:
	return not category.is_empty()
