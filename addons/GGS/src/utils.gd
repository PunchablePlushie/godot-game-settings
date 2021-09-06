extends Node
class_name GGSUtils
## A script containing various utility functions


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
