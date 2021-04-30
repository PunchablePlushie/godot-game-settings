tool
extends LineEdit

enum Type {Bool, Int, Float, Str, Arr, Dict}
var err_text: String
onready var Root: HBoxContainer = get_node("../..")


func _ready() -> void:
	hint_tooltip = "Default Value"
	err_text = "GGS - %02d/Default_Value: Entered value cannot be converted to"%[Root.get_index()]


func _on_DefaultField_text_entered(new_text: String) -> void:
	if Root.initialized == false:
		Root.AddScriptBtn.grab_focus()
		Root.AddScriptBtn.disabled = false
	
	var value = _to_suitable_type(new_text)
	ggsManager.settings_data[str(Root.get_index())]["default"] = value
	ggsManager.settings_data[str(Root.get_index())]["default_raw"] = new_text
	ggsManager.save_settings_data()
	
	print("GGS - %02d: Default value saved (%s)"%[Root.get_index(), value])


func _to_suitable_type(input: String):
	var type: int = ggsManager.settings_data[str(Root.get_index())]["value_type"]
	var value: String = input.to_lower()
	
	match type:
		Type.Bool:
			return _to_bool(value)
		Type.Int:
			return _to_int(value)
		Type.Float:
			return _to_float(value)
		Type.Str:
			return input
		Type.Arr:
			return _to_array(value)


func _to_bool(value: String):
	if value == "false" or value == "0":
		return false
	elif value == "true" or value == "1":
		return true
	else:
		printerr("%s boolean."%[err_text])
		return null


func _to_int(value: String):
	if value.is_valid_integer():
		return int(value)
	else:
		printerr("%s integer."%[err_text])
		return null


func _to_float(value: String):
	if value.is_valid_float():
		return float(value)
	else:
		printerr("%s float."%[err_text])
		return null


func _to_array(value: String):
	# Check if string is valid
	if not value.begins_with("[") or not value.ends_with("]"):
		printerr("%s array."%[err_text])
		return null

	# Clean up the string (in order: remove escape characters, remove whitespace, remove brackets)
	var trimmed_string: String = value.strip_escapes().strip_edges().trim_prefix("[").trim_suffix("]")
	
	# Create an array of strings and trim up the white space in every single item
	var arr: Array = trimmed_string.split(",", false)
	
	var arr2: Array = []
	for item in arr:
		arr2.append(item.dedent())
	
	# Get the type of each item
	var arr3: Array = []
	for item in arr2:
		arr3.append(item.split(":", false))
	
	# More trimming
	var arr4: Array = []
	for item in arr3:
		var arr5: Array = []
		for item2 in item:
			arr5.append(item2.dedent())
		arr4.append(arr5)
	
	# Convert each value to it's respective type
	var arr6: Array = []
	for item in arr4:
		var vv: String = item[0]
		var tt: String = item[1]
		match tt.to_lower():
			"float":
				if vv.is_valid_float():
					arr6.append(float(vv))
				else:
					printerr("GGS - %02d/Default_Value/Type_Array: One or more items in the array cannot be converted to float."%[Root.get_index()])
					return null
			"int":
				if vv.is_valid_integer():
					arr6.append(int(vv))
				else:
					printerr("GGS - %02d/Default_Value/Type_Array: One or more items in the array cannot be converted to integer."%[Root.get_index()])
					return null
			"string":
				arr6.append(vv)
	
	return arr6
