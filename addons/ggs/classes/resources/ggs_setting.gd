@tool
extends Resource
class_name ggsSetting

@export_category("Setting")
@export var name: String

@export_group("Internal")
@export var key: String
@export var category: String
@export var tree_item_id: int
@export var icon: Texture2D
@export_multiline var desc: String
