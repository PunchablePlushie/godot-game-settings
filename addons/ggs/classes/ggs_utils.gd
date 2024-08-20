@tool
extends RefCounted
class_name ggsUtils
## Provides utility methods used in GGS.

const ALL_HINTS: Dictionary = {
	0: "None",
	1: "Range",
	2: "Enum",
	3: "Enum Suggestion",
	4: "Exp Easing",
	5: "Link",
	6: "Flags",
	7: "Layers 2D Render",
	8: "Layers 2D Physics", 
	9: "Layers 2D Navigation",
	10: "Layers 3D Render",
	11: "Layers 3D Physics",
	12: "Layers 3D Navigation",
	13: "File",
	14: "Dir",
	15: "Global File",
	16: "Global Dir",
	17: "Resource Type",
	18: "Multiline Text",
	19: "Expression",
	20: "Placeholder Text",
	21: "Color No Alpha",
	22: "Object ID",
	23: "Type String",
	24: "_NODE_PATH_TO_NODE (DEPRECATED)",
	25: "Object too Big",
	26: "NodePath Valid Types",
	27: "Save File",
	28: "Global Save File",
	29: "_INT_IS_OBJECTID (DEPRECATED)",
	30: "Int is Pointer",
	31: "Array Type",
	32: "Locale ID",
	33: "Localizable String",
	34: "Node Type",
	35: "Hide Quaternion Edit",
	36: "Password",
	37: "Layers Avoidance",
	38: "_MAX (Enum Size = 38)",
}


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


static func type_get_compatible_hints(type: Variant.Type) -> PackedStringArray:
	var result: PackedStringArray
	var temp: PackedInt32Array
	
	temp.append(PROPERTY_HINT_NONE)
	match type:
		TYPE_FLOAT:
			temp.append(PROPERTY_HINT_RANGE)
			temp.append(PROPERTY_HINT_EXP_EASING)
		
		TYPE_INT:
			temp.append(PROPERTY_HINT_RANGE)
			temp.append(PROPERTY_HINT_ENUM)
			temp.append(PROPERTY_HINT_FLAGS)
			temp.append(PROPERTY_HINT_LAYERS_2D_RENDER)
			temp.append(PROPERTY_HINT_LAYERS_2D_PHYSICS)
			temp.append(PROPERTY_HINT_LAYERS_2D_NAVIGATION)
			temp.append(PROPERTY_HINT_LAYERS_3D_RENDER)
			temp.append(PROPERTY_HINT_LAYERS_3D_PHYSICS)
			temp.append(PROPERTY_HINT_LAYERS_3D_NAVIGATION)
			temp.append(PROPERTY_HINT_LAYERS_AVOIDANCE)
			temp.append(PROPERTY_HINT_INT_IS_POINTER)
		
		TYPE_STRING:
			temp.append(PROPERTY_HINT_ENUM)
			temp.append(PROPERTY_HINT_ENUM_SUGGESTION)
			temp.append(PROPERTY_HINT_FILE)
			temp.append(PROPERTY_HINT_DIR)
			temp.append(PROPERTY_HINT_GLOBAL_FILE)
			temp.append(PROPERTY_HINT_GLOBAL_DIR)
			temp.append(PROPERTY_HINT_MULTILINE_TEXT)
			temp.append(PROPERTY_HINT_EXPRESSION)
			temp.append(PROPERTY_HINT_PLACEHOLDER_TEXT)
			temp.append(PROPERTY_HINT_TYPE_STRING)
			temp.append(PROPERTY_HINT_SAVE_FILE)
			temp.append(PROPERTY_HINT_GLOBAL_SAVE_FILE)
			temp.append(PROPERTY_HINT_LOCALE_ID)
			temp.append(PROPERTY_HINT_PASSWORD)
		
		TYPE_VECTOR2, TYPE_VECTOR2I, TYPE_VECTOR3, TYPE_VECTOR3I, TYPE_VECTOR4, TYPE_VECTOR4I:
			temp.append(PROPERTY_HINT_LINK)
		
		TYPE_VECTOR2:
			temp.append(PROPERTY_HINT_LINK)
		
		TYPE_OBJECT:
			temp.append(PROPERTY_HINT_RESOURCE_TYPE)
			temp.append(PROPERTY_HINT_OBJECT_ID)
			temp.append(PROPERTY_HINT_OBJECT_TOO_BIG)
			temp.append(PROPERTY_HINT_NODE_TYPE)
		
		TYPE_COLOR:
			temp.append(PROPERTY_HINT_COLOR_NO_ALPHA)
		
		TYPE_ARRAY:
			temp.append(PROPERTY_HINT_TYPE_STRING)
			temp.append(PROPERTY_HINT_ARRAY_TYPE)
		
		TYPE_NODE_PATH:
			temp.append(PROPERTY_HINT_NODE_PATH_VALID_TYPES)
		
		TYPE_DICTIONARY:
			temp.append(PROPERTY_HINT_LOCALIZABLE_STRING)
		
		TYPE_QUATERNION:
			temp.append(PROPERTY_HINT_HIDE_QUATERNION_EDIT)
	
	for hint: PropertyHint in temp:
		result.append(ALL_HINTS[hint])
	
	return result


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
