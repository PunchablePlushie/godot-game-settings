extends Node
class_name Utils
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


static func str2int(value: String):
	if value.is_valid_integer():
		return int(value)
	else:
		return null


static func str2float(value: String):
	if value.is_valid_float():
		return float(value)
	else:
		return null


static func str2arr(value: String):
	# Check if string is valid
	if not value.begins_with("[") or not value.ends_with("]"):
		return null
	
	# Clean up the string
	var trimmed_string: String = value.trim_prefix("[").trim_suffix("]").strip_edges()
	
	# Create an array of strings and trim up the white space in every single item
	var arr0: Array = trimmed_string.split(",", false)
	
	var arr2: Array = []
	for item in arr0:
		arr2.append(item.strip_edges())
	
	# Get the type of each item
	var arr3: Array = []
	for item in arr2:
		arr3.append(item.split(":", false))
	
	# More trimming
	var arr4: Array = []
	for item in arr3:
		var arr5: Array = []
		for item2 in item:
			arr5.append(item2.strip_edges())
		arr4.append(arr5)
	
	# Convert each value to it's respective type
	var arr6: Array = []
	print(arr4)
	for item in arr4:
		var vv: String = item[0]
		var tt: String = item[1]
		prints(item, vv, tt)
		match tt.to_lower():
			"float":
				if vv.is_valid_float():
					arr6.append(float(vv))
				else:
					printerr("Utils - str2arr(): One or more items in the array cannot be converted to float.")
					return null
			"int":
				if vv.is_valid_integer():
					arr6.append(int(vv))
				else:
					printerr("Utils - str2arr(): One or more items in the array cannot be converted to integer.")
					return null
			"string":
				arr6.append(vv)
	
	return arr6


static func str2dict(value: String):
	# Check if the string is valid
	if not value.begins_with("{") or not value.ends_with("}"):
		return null
	
	# Clean up the string
	var trimmed_string: String = value.trim_prefix("{").trim_suffix("}").strip_edges()
	
	# Create an array of string and clean up
	var arr0: Array = trimmed_string.split(",", false)
	
	var arr1: Array = []
	for item in arr0:
		arr1.append(item.strip_edges())
	
	# Separate keys, values, and types
	var arr2: Array = []
	for item in arr1:
		arr2.append(item.split(":", false))
	
	# Clean up
	var arr3: Array = []
	for item in arr2:
		var arr4: Array = []
		for item2 in item:
			arr4.append(item2.strip_edges())
		arr3.append(arr4)
	
	# Convert each value to it's type and store as a dictionary
	var dict: Dictionary = {}
	for item in arr3:
		var kk: String = item[0]
		var vv: String = item[1]
		var tt: String = item[2]
		
		match tt.to_lower():
			"float":
				if vv.is_valid_float():
					dict[kk] = float(vv)
				else:
					printerr("Utils - str2dict(): One or more values in the dictionary cannot be converted to float.")
					return null
			"int":
				if vv.is_valid_integer():
					dict[kk] = int(vv)
				else:
					printerr("Utils - str2dict(): One or more values in the dictionary cannot be converted to integer.")
					return null
			"string":
				dict[kk] = vv
	
	return dict

