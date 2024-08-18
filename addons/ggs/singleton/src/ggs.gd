@tool
extends Node
class_name ggsCore
## The core GGS singleton. Handles everything that needs a persistent
## and global instance to function.

enum ItemType {NIL, CATEGORY, GROUP, SETTING}
enum NotifType {NAME_INVALID, NAME_EXISTS}

@export_group("Nodes")
@export var Util: Node
@export var Pref: Node
@export var State: Node
@export var Event: Node
@export var GameConfig: Node
