@tool
extends PopupMenu

enum ItemId {RENAME, DELETE, FILESYSTEM_GODOT, FILESYSTEM_OS, RELOAD}

@export_group("Icons", "icon_")
@export var icon_rename: Texture2D
@export var icon_delete: Texture2D
@export var icon_filesystem_godot: Texture2D
@export var icon_filesystem_os: Texture2D
@export var icon_reload: Texture2D


func _ready() -> void:
	_init_items()


func set_category_actions_disabled(disabled: bool) -> void:
	var item_idx: int = get_item_index(ItemId.RENAME)
	set_item_disabled(item_idx, disabled)
	
	item_idx = get_item_index(ItemId.DELETE)
	set_item_disabled(item_idx, disabled)
	
	item_idx = get_item_index(ItemId.FILESYSTEM_GODOT)
	set_item_disabled(item_idx, disabled)
	
	item_idx = get_item_index(ItemId.FILESYSTEM_OS)
	set_item_disabled(item_idx, disabled)


func _init_items() -> void:
	clear()
	
	add_icon_item(icon_rename, "Rename", ItemId.RENAME)
	add_icon_item(icon_delete, "Delete", ItemId.DELETE)
	add_separator()
	add_icon_item(icon_filesystem_godot, "Show in FileSystem Dock", ItemId.FILESYSTEM_GODOT)
	add_icon_item(icon_filesystem_os, "Show in OS File Manager", ItemId.FILESYSTEM_OS)
	add_separator()
	add_icon_item(icon_reload, "Reload List", ItemId.RENAME)
