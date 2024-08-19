@tool
extends Node
class_name ggsCore
## The core GGS singleton. Handles everything that needs a persistent
## and global instance to function.

@export var Pref: ggsPreferences

@export_group("Nodes")
@export var Events: Node
@export var GameConfig: Node
