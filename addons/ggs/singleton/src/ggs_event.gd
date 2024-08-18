@tool
extends Node
## Hosts all events and signals related to the GGS editor.

signal notif_requested(type: ggsCore.NotifType)
signal notif_closed(type: ggsCore.NotifType)

signal rename_requested(item_type: ggsCore.ItemType, item_name: String)
signal rename_confirmed(item_type: ggsCore.ItemType, prev_name:String, new_name: String)

signal delete_requested(item_type: ggsCore.ItemType, item_name: String)
signal delete_confirmed(item_type: ggsCore.ItemType, item_name: String)

signal ui_vis_changed(pref_cat: String, ui: String, vis: bool)

signal item_selected(item_type: ggsCore.ItemType, item_name: String)
