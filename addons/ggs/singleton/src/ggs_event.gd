@tool
extends Node
## Hosts all events and signals related to the GGS editor.

signal notif_requested(type: ggsCore.NotifType)
signal notif_closed(type: ggsCore.NotifType)

signal item_selected(item_type: ggsCore.ItemType, item_name: String)

## Emitted [i]after[/i] the [code]*_selected[/code] properties in ggsState
## are updated. This will ensure that objects that rely on the value of
## the [code]*_selected[/code] properties work correctly.
signal item_post_select(item_type: ggsCore.ItemType, item_name: String)
