@tool
extends ItemList

var _types: PackedStringArray = ggsUtils.ALL_TYPES.values()

var EditorControl: Control


func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	
	EditorControl = EditorInterface.get_base_control()
	clear()
	_create_from_arr(_types)


func filter(input: String) -> void:
	clear()
	
	if input.is_empty():
		_create_from_arr(_types)
		return
	
	var types_filtered: Array = Array(_types).filter(_filter_method.bind(input))
	_create_from_arr(PackedStringArray(types_filtered))


func _create_from_arr(arr: PackedStringArray) -> void:
	for type: String in arr:
		var icon: Texture2D = EditorControl.get_theme_icon(type, "EditorIcons")
		add_item(type, icon)


func _filter_method(element: String, input: String) -> bool:
	var element_lowered: String = element.to_lower()
	var input_lowered: String = input.to_lower()
	return element_lowered.begins_with(input_lowered)
