@tool
extends ggsBaseSelectList


func _ready() -> void:
	base_items = ggsUtils.ALL_TYPES.values()
	clear()
	create_from_arr(base_items)


func create_from_arr(arr: PackedStringArray) -> void:
	var EditorControl: Control = EditorInterface.get_base_control()
	for type: String in arr:
		var icon: Texture2D = EditorControl.get_theme_icon(type, "EditorIcons")
		add_item(type, icon)
