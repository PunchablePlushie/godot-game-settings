@tool
extends ggsSetting

var size_setting: String = "[NONE]": set = set_size_setting


func _init() -> void:
	name = "Fullscreen Mode"
	icon = preload("res://addons/ggs/assets/game_settings/display_fullscreen.svg")
	desc = "Toggle Fullscreen mode."
	
	value_type = TYPE_BOOL
	default = false


func apply(value: bool) -> void:
	var window_mode: DisplayServer.WindowMode
	match value:
		true:
			window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		false:
			window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	
	DisplayServer.window_set_mode(window_mode)
	
	if size_setting != "[NONE]":
		_apply_size_setting()


func _apply_size_setting() -> void:
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var setting: ggsSetting = data.categories[category].settings[size_setting]
	setting.apply(setting.current)


### Size Setting

func set_size_setting(value: String) -> void:
	size_setting = value
	
	if is_added():
		save_plugin_data()


func _get_property_list() -> Array:
	if not is_added():
		return []
	
	var hint_string: String = ",".join(_get_other_settings())
	
	var properties: Array
	properties.append({
		"name": "size_setting",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": hint_string,
	})
	
	return properties


func _get_other_settings() -> PackedStringArray:
	var other_settings: PackedStringArray = ["[NONE]"]
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var settings: Dictionary = data.categories[category].settings
	for setting in settings.values():
		if setting.name == name:
			continue
		
		other_settings.append(setting.name)
	
	return other_settings
