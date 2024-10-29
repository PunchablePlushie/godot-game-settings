@tool
extends ggsBaseSelectList


func _ready() -> void:
	base_items = ggsUtils.ALL_TYPES.values()
	clear()
	create_from_arr(base_items)


func create_from_arr(arr: PackedStringArray) -> void:
	var BaseControl: Control
	if Engine.is_editor_hint():
		var editor_interface: Object = Engine.get_singleton("EditorInterface")
		BaseControl = editor_interface.get_base_control()

	if BaseControl == null:
		return

	for type: String in arr:
		var icon: Texture2D = BaseControl.get_theme_icon(type, "EditorIcons")
		add_item(type, icon)
