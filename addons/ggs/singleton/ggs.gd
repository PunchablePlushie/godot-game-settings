@tool
extends Node
class_name ggsCore
## The core GGS singleton. Handles everything that needs a persistent
## and global instance to function.

@export_group("Nodes")
@export var GameConfig: Node
