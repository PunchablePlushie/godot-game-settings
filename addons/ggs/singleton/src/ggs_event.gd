@tool
extends Node
## Hosts all events and signals related to the GGS editor.

## Emitted when the currently open notification dialog is closed.
signal notif_closed()

## Emitted when a node requests a notification dialog
signal notif_requested(title: String, text: String)

## Emitted when the visibility of a UI element is changed from the
## UI Visibility menu
signal ui_vis_changed(pref_cat: String, ui: String, vis: bool)

## Emitted when a category is selected in the Categories Panel.
signal category_selected(category: String)

## Emitted when a group is selected in the Groups Panel.
signal group_selected(group: String)


signal setting_selected()
