extends Node
class_name GGSUtils
## A script containing various utility functions
const DEFAULT_SECTION:= "settings"

static func save_json(data: Dictionary, path: String) -> void:
	var data_stringified: String = JSON.print(data)
	var file: File = File.new()
	var err: int = file.open(path, File.WRITE)
	if err == OK:
		var data_beautified: String = JSONBeautifier.beautify_json(data_stringified)
		file.store_string(data_beautified)
		file.close()


static func load_json(path: String) -> Dictionary:
	var data: String = ""
	var file: File = File.new()
	var err: int = file.open(path, File.READ)
	if err == OK:
		data = file.get_as_text()
		file.close()
	var result: JSONParseResult = JSON.parse(data)
	return result.result


static func save_cfg(data: Dictionary, path: String) -> void:
	var _config_file = ConfigFile.new()
	_config_file.set_value(DEFAULT_SECTION, DEFAULT_SECTION, data)
	var err = _config_file.save(path)
	if err == ERR_FILE_NOT_FOUND:
		pass
	elif err != OK:
		printerr("Failed to load settings file")


static func load_cfg(path: String) -> Dictionary:
	var _config_file = ConfigFile.new()
	var err = _config_file.load(path)
	if err == ERR_FILE_NOT_FOUND:
		pass
	elif err != OK:
		printerr("Failed to load settings file")
	var ret = _config_file.get_value(DEFAULT_SECTION, DEFAULT_SECTION, null)

	if ret:
		var new_ret = {}
		var keys = ret.keys()
		var new_keys = []
		for cur_key in keys:
			new_keys.append(int(cur_key))
		new_keys.sort()
		for cur_key in new_keys:
			new_ret[str(cur_key)] = ret[str(cur_key)]
		return new_ret
	return {}

static func array_find_type(array: Array, type: String) -> Object:
	for item in array:
		var item_class: String = item.get_class()
		if item_class == type:
			return item
		else:
			continue
	return null


static func str2bool(value: String):
	var val = value.to_lower()
	if val == "false" or val == "0":
		return false
	elif val == "true" or val == "1":
		return true
	else:
		return null


static func str2float(value: String):
	if value.is_valid_float():
		return float(value)
	else:
		return null
