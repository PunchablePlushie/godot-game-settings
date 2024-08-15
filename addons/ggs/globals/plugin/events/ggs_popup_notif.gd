@tool
extends Object
class_name ggsPopupNotif
## Hosts signals related to notifying the user via a popup, usually a window.

## User has used an invalid item name when creating a category, group, etc.
signal name_invalid()

## User has used an already existing name when creating a category, group, etc.
signal name_exists()
