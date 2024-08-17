@tool
extends Node
## Hosts all events and signals related to the GGS editor.

## Emitted when a notification dialog is closed.
signal notif_popup_closed

## Emitted when the visibility of a UI element is changed from the
## UI Visibility menu
signal ui_vis_changed(pref_cat: String, ui: String, vis: bool)

## Emitted when a category is selected in the Categories Panel.
signal category_selected()
signal group_selected()
signal setting_selected()
signal reload_categories_requested()
