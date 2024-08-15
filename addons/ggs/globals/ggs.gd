@tool
extends Node
## The core GGS singleton. Handles everything that needs a persistent and global instance to function.

## Reference to the [ggsPluginState] instance
var State: ggsPluginState

## Reference to the [ggsPluginEvent] instance
var Event: ggsPluginEvent


func _ready() -> void:
	if Engine.is_editor_hint():
		State = ggsPluginState.new()
		Event = ggsPluginEvent.new()
