@tool
extends Node
## Provides various functions used throughout GGS.

@export_group("Nodes")
@export var _Pref: Node
@export var _State: Node
@export var _Event: Node


func _ready() -> void:
	_Event.rename_confirmed.connect(_on_Global_rename_confirmed)
	_Event.delete_confirmed.connect(_on_Global_delete_confirmed)


func remove_underscored(list: PackedStringArray) -> PackedStringArray:
	var filter_method: Callable = func(e): return not e.begins_with("_")
	var filtered_list: Array = Array(list).filter(filter_method)
	return PackedStringArray(filtered_list)


func get_item_path(item_type: ggsCore.ItemType, item_name: String) -> String:
	var path: String = GGS.Pref.data.paths["settings"]
	match item_type:
		ggsCore.ItemType.CATEGORY:
			path = path.path_join(item_name)
		ggsCore.ItemType.GROUP:
			path = path.path_join(_State.selected_category)
			path = path.path_join(item_name)
	
	return path


#region Item Name Validation
func validate_item_name(item_type: ggsCore.ItemType, item_name: String) -> bool:
	if not _item_name_is_valid(item_name):
		GGS.Event.notif_requested.emit(ggsCore.NotifType.NAME_INVALID)
		return false
	
	if _item_name_exists(item_type, item_name):
		GGS.Event.notif_requested.emit(ggsCore.NotifType.NAME_EXISTS)
		return false
	
	return true


func _item_name_is_valid(item_name: String) -> bool:
	return (
		item_name.is_valid_filename() 
		and not item_name.begins_with("_") 
		and not item_name.begins_with(".")
	)


func _item_name_exists(item_type: ggsCore.ItemType, item_name: String) -> bool:
	var path: String = get_item_path(item_type, item_name)
	return DirAccess.dir_exists_absolute(path)

#endregion

#region Item Actions
func show_item_in_filesystem_godot(item_type: ggsCore.ItemType, item_name: String) -> void:
	var path: String = get_item_path(item_type, item_name)
	EditorInterface.get_file_system_dock().navigate_to_path(path)


func show_item_in_filesystem_os(item_type: ggsCore.ItemType, item_name: String) -> void:
	var path: String = get_item_path(item_type, item_name)
	
	path = ProjectSettings.globalize_path(path)
	OS.shell_show_in_file_manager(path)


func _on_Global_rename_confirmed(item_type: ggsCore.ItemType, prev_name:String, new_name: String) -> void:
	var from: String = get_item_path(item_type, prev_name)
	var to: String = get_item_path(item_type, new_name)
	
	DirAccess.rename_absolute(from, to)
	EditorInterface.get_resource_filesystem().scan()


func _on_Global_delete_confirmed(item_type: ggsCore.ItemType, item_name: String) -> void:
	var path: String = get_item_path(item_type, item_name)
	path = ProjectSettings.globalize_path(path)
	
	OS.move_to_trash(path)
	EditorInterface.get_resource_filesystem().scan()

#endregion

# ooooooooooooooooo #
static func get_enum_string(target_enum: String) -> String:
	var types: PackedStringArray = [
		"Nil","Bool","Int","Float","String","Vector2","Vector2i","Rect2",
		"Rect2i","Vector3","Vector3i","Transform2D","Vector4","Vector4i","Plane",
		"Quaternion","AABB","Basis","Transform3D","Projection","Color",
		"StringName","NodePath","RID","Object","Callable","Signal","Dictionary",
		"Array","PackedByteArray","PackedInt32Array","PackedInt64Array",
		"PackedFloat32Array","PackedFloat64Array","PackedStringArray",
		"PackedVector2Array","PackedVector3Array","PackedColorArray"
	]
	
	var property_hints: PackedStringArray = [
		"None","Range","Enum","Enum Suggestion","Exp Easing","Link","Flags",
		"Layers 2D Render","Layers 2D Physics","Layers 2D Navigation",
		"Layers 3D Render","Layers 3D Physics","Layers 3D Navigation",
		"File","Dir","Global File","Global Dir","Resource Type","Multiline Text",
		"Expression","Placeholder Text","Color No Alpha","Object ID","Type String",
		"Node Path To Edited Node","Object Too Big","Node Path Valid Types",
		"Save File","Global Save File","Int is Object ID","Int is Pointer",
		"Array Type","Locale ID","Localizable String","Node Type",
		"Hide Quaternion Edit","Password"
	]
	
	var enum_string: String
	match target_enum:
		"Variant.Type":
			enum_string = ",".join(types)
		"PropertyHint":
			enum_string = ",".join(property_hints)
	
	return enum_string


# Window

static func window_clamp_to_screen(size: Vector2) -> Vector2:
	var screen_size: Rect2i = DisplayServer.screen_get_usable_rect()
	size.x = min(size.x, screen_size.size.x)
	size.y = min(size.y, screen_size.size.y)
	
	return size


static func center_window() -> void:
	var screen_id: int = DisplayServer.window_get_current_screen()
	var display_size: Vector2i = DisplayServer.screen_get_size(screen_id)
	var window_size: Vector2i = DisplayServer.window_get_size()
	var origin: Vector2i = DisplayServer.screen_get_position(screen_id)
	var target_pos: Vector2 = origin + (display_size / 2) - (window_size / 2)
	DisplayServer.window_set_position(target_pos)
