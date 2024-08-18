@tool
extends Node
## Hosts all events and signals related to the GGS editor.

signal notif_requested(type: ggsCore.NotifType)
signal notif_closed(type: ggsCore.NotifType)

signal item_selected(item_type: ggsCore.ItemType, item_name: String)
