@tool
extends Node
## Provides various functions used throughout GGS.

@export var popup_notif: PackedScene
@export var popup_rename: PackedScene
@export var popup_delete: PackedScene


#region Item Name Validation
## Checks whether [param item_name] is valid and can be used.[br]
## A valid name is a valid file name, does not start with dot or underscore
## ,and does not already exist.
func item_name_validate(item_name: String, category: String = "", group: String = "") -> bool:
	if not _item_name_is_valid(item_name):
		var Notif: AcceptDialog = popup_notif.instantiate()
		Notif.set_content(Notif.Type.NAME_INVALID)
		add_child(Notif)
		return false
	
	if _item_name_exists(item_name, category, group):
		var Notif: AcceptDialog = popup_notif.instantiate()
		Notif.set_content(Notif.Type.NAME_EXISTS)
		add_child(Notif)
		return false
	
	return true


func _item_name_is_valid(item_name: String) -> bool:
	return (
		item_name.is_valid_filename() 
		and not item_name.begins_with("_") 
		and not item_name.begins_with(".")
	)


func _item_name_exists(item_name: String, category: String, group: String) -> bool:
	var settings_path: String = GGS.Pref.res.paths["settings"]
	var final_path: String = settings_path.path_join(category).path_join(group)
	var dir: DirAccess = DirAccess.open(final_path)
	return dir.dir_exists(item_name)

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
