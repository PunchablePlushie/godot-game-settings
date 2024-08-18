@tool
extends PopupMenu
class_name ggsBaseContextMenu

enum ItemId {RENAME, DELETE, FILESYSTEM_GODOT, FILESYSTEM_OS, RELOAD}

@export_group("Labels", "label_")
@export var label_rename: String
@export var label_delete: String
@export var label_filesystem_godot: String
@export var label_filesystem_os: String
@export var label_reload: String
@export_group("Icons", "icon_")
@export var icon_rename: Texture2D
@export var icon_delete: Texture2D
@export var icon_filesystem_godot: Texture2D
@export var icon_filesystem_os: Texture2D
@export var icon_reload: Texture2D


func _init() -> void:
	visible = false


func _ready() -> void:
	_populate()


func set_item_actions_disabled(disabled: bool) -> void:
	var idx: int = get_item_index(ItemId.RENAME)
	set_item_disabled(idx, disabled)
	
	idx = get_item_index(ItemId.DELETE)
	set_item_disabled(idx, disabled)
	
	idx = get_item_index(ItemId.FILESYSTEM_GODOT)
	set_item_disabled(idx, disabled)
	
	idx = get_item_index(ItemId.FILESYSTEM_OS)
	set_item_disabled(idx, disabled)


func _populate() -> void:
	clear()
	add_icon_item(icon_rename, label_rename, ItemId.RENAME)
	add_icon_item(icon_delete, label_delete, ItemId.DELETE)
	add_separator()
	add_icon_item(icon_filesystem_godot, label_filesystem_godot, ItemId.FILESYSTEM_GODOT)
	add_icon_item(icon_filesystem_os, label_filesystem_os, ItemId.FILESYSTEM_OS)
	add_separator()
	add_icon_item(icon_reload, label_reload, ItemId.RELOAD)
