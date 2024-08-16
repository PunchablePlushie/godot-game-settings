@tool
extends Node
## The core GGS singleton. Handles everything that needs a persistent and global instance to function.

## Reference to the global [ggsPluginState] instance.
var State: ggsPluginState

## Reference to the global [ggsPluginEvent] instance.
var Event: ggsPluginEvent

## Reference to the global [ggsGameConfig] instance.
var GameConfig: ggsGameConfig


func _ready() -> void:
	# GGS editor stuff are unnecessary in runtime.
	if Engine.is_editor_hint():
		State = ggsPluginState.new()
		Event = ggsPluginEvent.new()
	
	GameConfig = ggsGameConfig.new()
