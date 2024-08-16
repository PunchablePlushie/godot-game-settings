@tool
extends Node
## Hosts all events and signals related to the GGS editor.

## Emitted when a notification dialog is closed.
signal notif_popup_closed


## Emitted when a category is selected in the Categories Panel.
signal category_selected()
signal group_selected()
signal setting_selected()
signal reload_categories_requested()
