@tool
extends RefCounted
class_name ggsPluginEvent
## Hosts all events and signals related to the GGS editor.

## Emitted when a category is selected in the Categories Panel.
signal category_selected()
signal group_selected()
signal setting_selected()
signal reload_categories_requested()

## Reference to the global [ggsPopupNotif] instance.
var PopupNotif: ggsPopupNotif = ggsPopupNotif.new()
