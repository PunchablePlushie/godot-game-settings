@tool
extends RefCounted
class_name ggsPopupNotif
## Hosts signals for notifying core popup windows.

## User has used an invalid item name when creating a category, group, etc.
signal name_invalid

## User has used an already existing name when creating a category, group, etc.
signal name_exists

## Emited when the notification popup is closed
signal notif_closed

## User intends to rename a category.
signal category_rename_requested(cat_name: String)
signal category_rename_resolved(prev_name: String, new_name: String)
