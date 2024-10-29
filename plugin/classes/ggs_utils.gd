@tool
extends RefCounted
class_name ggsUtils
## Provides utility methods used in GGS.

const ALL_TYPES: Dictionary = {
	TYPE_BOOL: "bool",
	TYPE_INT: "int",
	TYPE_FLOAT: "float",
	TYPE_STRING: "String",
	TYPE_VECTOR2: "Vector2",
	TYPE_VECTOR2I: "Vector2i",
	TYPE_RECT2: "Rect2",
	TYPE_RECT2I: "Rect2i",
	TYPE_VECTOR3: "Vector3",
	TYPE_VECTOR3I: "Vector3i",
	TYPE_TRANSFORM2D: "Transform2D",
	TYPE_VECTOR4: "Vector4",
	TYPE_VECTOR4I: "Vector4i",
	TYPE_PLANE: "Plane",
	TYPE_QUATERNION: "Quaternion",
	TYPE_AABB: "AABB",
	TYPE_BASIS: "Basis",
	TYPE_TRANSFORM3D: "Transform3D",
	TYPE_PROJECTION: "Projection",
	TYPE_COLOR: "Color",
	TYPE_STRING_NAME: "StringName",
	TYPE_NODE_PATH: "NodePath",
	TYPE_RID: "RID",
	TYPE_OBJECT: "Object",
	TYPE_CALLABLE: "Callable",
	TYPE_SIGNAL: "Signal",
	TYPE_DICTIONARY: "Dictionary",
	TYPE_ARRAY: "Array",
	TYPE_PACKED_BYTE_ARRAY: "PackedByteArray",
	TYPE_PACKED_INT32_ARRAY: "PackedInt32Array",
	TYPE_PACKED_INT64_ARRAY: "PackedInt64Array",
	TYPE_PACKED_FLOAT32_ARRAY: "PackedFloat32Array",
	TYPE_PACKED_FLOAT64_ARRAY: "PackedFloat64Array",
	TYPE_PACKED_STRING_ARRAY: "PackedStringArray",
	TYPE_PACKED_VECTOR2_ARRAY: "PackedVector2Array",
	TYPE_PACKED_VECTOR3_ARRAY: "PackedVector3Array",
	TYPE_PACKED_VECTOR4_ARRAY: "PackedVector4Array",
	TYPE_PACKED_COLOR_ARRAY: "PackedColorArray",
}

const ALL_HINTS: Dictionary = {
	PROPERTY_HINT_NONE: "None",
	PROPERTY_HINT_RANGE: "Range",
	PROPERTY_HINT_ENUM: "Enum",
	PROPERTY_HINT_ENUM_SUGGESTION: "Enum Suggestion",
	PROPERTY_HINT_EXP_EASING: "Exp Easing",
	PROPERTY_HINT_LINK: "Link",
	PROPERTY_HINT_FLAGS: "Flags",
	PROPERTY_HINT_LAYERS_2D_RENDER: "Layers 2D Render",
	PROPERTY_HINT_LAYERS_2D_PHYSICS: "Layers 2D Physics",
	PROPERTY_HINT_LAYERS_2D_NAVIGATION: "Layers 2D Navigation",
	PROPERTY_HINT_LAYERS_3D_RENDER: "Layers 3D Render",
	PROPERTY_HINT_LAYERS_3D_PHYSICS: "Layers 3D Physics",
	PROPERTY_HINT_LAYERS_3D_NAVIGATION: "Layers 3D Navigation",
	PROPERTY_HINT_LAYERS_AVOIDANCE: "Layers Avoidance",
	PROPERTY_HINT_FILE: "File",
	PROPERTY_HINT_DIR: "Dir",
	PROPERTY_HINT_GLOBAL_FILE: "Global File",
	PROPERTY_HINT_GLOBAL_DIR: "Global Dir",
	PROPERTY_HINT_RESOURCE_TYPE: "Resource Type",
	PROPERTY_HINT_MULTILINE_TEXT: "Multiline Text",
	PROPERTY_HINT_EXPRESSION: "Expression",
	PROPERTY_HINT_PLACEHOLDER_TEXT: "Placeholder Text",
	PROPERTY_HINT_COLOR_NO_ALPHA: "Color No Alpha",
	PROPERTY_HINT_OBJECT_ID: "Object ID",
	PROPERTY_HINT_TYPE_STRING: "Type String",
	PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE: "_NODE_PATH_TO_EDITED_NODE (DEPRECATED)",
	PROPERTY_HINT_OBJECT_TOO_BIG: "Object too Big",
	PROPERTY_HINT_NODE_PATH_VALID_TYPES: "NodePath Valid Types",
	PROPERTY_HINT_SAVE_FILE: "Save File",
	PROPERTY_HINT_GLOBAL_SAVE_FILE: "Global Save File",
	PROPERTY_HINT_INT_IS_OBJECTID: "_INT_IS_OBJECTID (DEPRECATED)",
	PROPERTY_HINT_INT_IS_POINTER: "Int is Pointer",
	PROPERTY_HINT_ARRAY_TYPE: "Array Type",
	PROPERTY_HINT_LOCALE_ID: "Locale ID",
	PROPERTY_HINT_LOCALIZABLE_STRING: "Localizable String",
	PROPERTY_HINT_NODE_TYPE: "Node Type",
	PROPERTY_HINT_HIDE_QUATERNION_EDIT: "Hide Quaternion Edit",
	PROPERTY_HINT_PASSWORD: "Password",
}

## Used to create the default value of a type when the user changes the
## [member ggsSetting.value_type] of a [ggsSetting].
static var TYPE_DEFAULTS: Dictionary = {
	TYPE_BOOL: false,
	TYPE_INT: 0,
	TYPE_FLOAT: 0.0,
	TYPE_STRING: "",
	TYPE_VECTOR2: Vector2(),
	TYPE_VECTOR2I: Vector2i(),
	TYPE_RECT2: Rect2(),
	TYPE_RECT2I: Rect2i(),
	TYPE_VECTOR3: Vector3(),
	TYPE_VECTOR3I: Vector3i(),
	TYPE_TRANSFORM2D: Transform2D(),
	TYPE_VECTOR4: Vector4(),
	TYPE_VECTOR4I: Vector4i(),
	TYPE_PLANE: Plane(),
	TYPE_QUATERNION: Quaternion(),
	TYPE_AABB: AABB(),
	TYPE_BASIS: Basis(),
	TYPE_TRANSFORM3D: Transform3D(),
	TYPE_PROJECTION: Projection(),
	TYPE_COLOR: Color(),
	TYPE_STRING_NAME: StringName(),
	TYPE_NODE_PATH: NodePath(),
	TYPE_RID: RID(),
	TYPE_OBJECT: null,
	TYPE_CALLABLE: Callable(),
	TYPE_SIGNAL: Signal(),
	TYPE_DICTIONARY: Dictionary(),
	TYPE_ARRAY: Array(),
	TYPE_PACKED_BYTE_ARRAY: PackedByteArray(),
	TYPE_PACKED_INT32_ARRAY: PackedInt32Array(),
	TYPE_PACKED_INT64_ARRAY: PackedInt64Array(),
	TYPE_PACKED_FLOAT32_ARRAY: PackedFloat32Array(),
	TYPE_PACKED_FLOAT64_ARRAY: PackedFloat64Array(),
	TYPE_PACKED_STRING_ARRAY: PackedStringArray(),
	TYPE_PACKED_VECTOR2_ARRAY: PackedVector2Array(),
	TYPE_PACKED_VECTOR3_ARRAY: PackedVector3Array(),
	TYPE_PACKED_VECTOR4_ARRAY: PackedColorArray(),
	TYPE_PACKED_COLOR_ARRAY: PackedVector4Array(),
}

## Returns the Editor icon associated with the given [param type].
static func type_get_icon(type: Variant.Type) -> Texture2D:
	var BaseControl: Control
	if Engine.is_editor_hint():
		var editor_interface: Object = Engine.get_singleton("EditorInterface")
		BaseControl = editor_interface.get_base_control()

	if BaseControl == null:
		return null

	var type_string: String = ALL_TYPES[type]
	return BaseControl.get_theme_icon(type_string, "EditorIcons")


## Returns [PropertyHints] associated with the given [param type].
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


## Clamps game window size to the current screen size. Used when window
## scale would resize the window to something larger than the user's screen.
static func window_clamp_to_screen(size: Vector2) -> Vector2:
	var screen_id: int = DisplayServer.window_get_current_screen()
	var screen_size: Rect2i = DisplayServer.screen_get_usable_rect(screen_id)

	return size.clamp(size, screen_size.size)


## Centers game window on the current screen.
static func window_center() -> void:
	var screen_id: int = DisplayServer.window_get_current_screen()
	var screen_size: Rect2i = DisplayServer.screen_get_usable_rect(screen_id)
	var window_size: Vector2i = DisplayServer.window_get_size()
	var origin: Vector2i = DisplayServer.screen_get_position(screen_id)
	var target_pos: Vector2 = origin + (screen_size.size / 2) - (window_size / 2)
	DisplayServer.window_set_position(target_pos)
