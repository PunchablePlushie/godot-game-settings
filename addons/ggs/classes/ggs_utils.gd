@tool
extends RefCounted
class_name ggsUtils
## Provides utility methods used in GGS.


static func get_all_types() -> PackedStringArray:
	return [
		"Nil","bool","int","float","String","Vector2","Vector2i","Rect2",
		"Rect2i","Vector3","Vector3i","Transform2D","Vector4","Vector4i",
		"Plane", "Quaternion","AABB","Basis","Transform3D","Projection",
		"Color", "StringName","NodePath","RID","Object","Callable",
		"Signal","Dictionary", "Array","PackedByteArray","PackedInt32Array",
		"PackedInt64Array", "PackedFloat32Array","PackedFloat64Array",
		"PackedStringArray", "PackedVector2Array","PackedVector3Array",
		"PackedColorArray",
	]


static func get_type_string(type: Variant.Type) -> String:
	return get_all_types()[type]


static func get_type_icon(type: Variant.Type) -> Texture2D:
	var BaseControl: Control = EditorInterface.get_base_control()
	var type_string: String = get_type_string(type)
	return BaseControl.get_theme_icon(type_string, "EditorIcons")


static func get_enum_string(target_enum: String) -> String:
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
