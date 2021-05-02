tool
extends HBoxContainer

enum Type {Name, ValueType, ScriptPath}
onready var TypeBtn: OptionButton = $OptionButton
onready var Field: LineEdit = $LineEdit
onready var Root: Control = get_node("../../../../..")


func commence_search(new_text: String) -> void:
	var items_list: Array = Root.SettingsList.get_children()
	
	# Reset search
	if new_text == "":
		for item in items_list:
			item.visible = true
		return
	
	# Search
	match TypeBtn.selected:
		Type.Name:
			_search_name(new_text)
		Type.ValueType:
			_search_value_type(new_text)
		Type.ScriptPath:
			_search_script(new_text)


func _search_name(new_text: String) -> void:
	var items_list: Array = Root.SettingsList.get_children()
	var regex: RegEx = RegEx.new()
	regex.compile("^%s"%[new_text])
	
	for item in items_list:
		var reg_result: RegExMatch = regex.search(item.NameField.text)
		if reg_result != null and reg_result.get_string() != "":
			item.visible = true
		else:
			item.visible = false


func _search_value_type(new_text: String) -> void:
	var items_list: Array = Root.SettingsList.get_children()
	var target_index: int
	match new_text.to_lower():
		"bool":
			target_index = 0
		"boolean":
			target_index = 0
		"int":
			target_index = 1
		"integer":
			target_index = 1
		"flt":
			target_index = 2
		"float":
			target_index = 2
		"str":
			target_index = 3
		"string":
			target_index = 3
		"arr":
			target_index = 4
		"array":
			target_index = 4
		"dict":
			target_index = 5
		"dictionary":
			target_index = 5
		_:
			target_index = -1
	
	for item in items_list:
		if item.DefaultType.selected == target_index:
			item.visible = true
		else:
			item.visible = false


func _search_script(new_text: String) -> void:
	var items_list: Array = Root.SettingsList.get_children()
	var regex: RegEx = RegEx.new()
	regex.compile("%s"%[new_text])
	
	for item in items_list:
		var subject: String = item.EditScriptBtn.hint_tooltip.trim_prefix("%s: "%[item.EditScriptBtn.BASE_TOOLTIP])
		var reg_result: RegExMatch = regex.search(subject)
		if reg_result != null and reg_result.get_string() != "":
			item.visible = true
		else:
			item.visible = false


func _on_LineEdit_text_changed(new_text: String) -> void:
	commence_search(new_text)


func _on_OptionButton_item_selected(index: int) -> void:
	commence_search(Field.text)
