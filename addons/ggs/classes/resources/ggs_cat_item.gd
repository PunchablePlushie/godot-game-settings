@tool
extends Resource
class_name ggsCatItem

@export_category("Category Item")
@export_group("Item Internals")
@export var icon: Texture2D
@export_multiline var desc: String
@export var category: String
@export var tree_item_id: int
