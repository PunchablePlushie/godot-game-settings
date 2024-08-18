@tool
extends Node
## Provides information regarding the current state of the GGS editor.

@export_group("Nodes")
@export var _Event: Node

var selected_category: String
var selected_group: String
var selected_setting: String


func _ready() -> void:
	_Event.item_selected.connect(_on_Global_item_selected)


func _on_Global_item_selected(item_type: ggsCore.ItemType ,item_name: String) -> void:
	match item_type:
		ggsCore.ItemType.CATEGORY:
			selected_category = item_name
		ggsCore.ItemType.GROUP:
			selected_group = item_name
		ggsCore.ItemType.SETTING:
			selected_setting = item_name
		
