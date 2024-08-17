@tool
extends Node
## The core GGS singleton. Handles everything that needs a persistent and global instance to function.

@export_group("Nodes")
## Provides various functions used throughout GGS.
@export var Util: Node

## Manages plugin preferences and data.
@export var Pref: Node

## Provides information regarding the current state of the GGS editor.
@export var State: Node

## Hosts all events and signals related to the GGS editor.
@export var Event: Node

## Handles everything related to game settings at runtime.
@export var GameConfig: Node
