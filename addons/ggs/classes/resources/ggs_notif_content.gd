@tool
extends Resource
class_name ggsNotifContent
## Simple resources containing message that can be used for popup windows
## or print calls.

## Title. Only applicable when used for a popup window.
@export var title: String

## Message text.
@export_multiline var text: String
