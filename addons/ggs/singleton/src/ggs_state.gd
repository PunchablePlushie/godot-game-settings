@tool
extends Node
## Provides information regarding the current state of the GGS editor.

@export_group("Nodes")
@export var Event: Node

## The currently selected category in the editor.
## [code]null[/code] means no category is selected.
var selected_category: String

## The currently selected group in the editor.
## [code]null[/code] means no group is selected. 
var selected_group: String

## The currently selected setting  in the editor. 
## [code]null[/code] means no setting is selected.
var selected_setting: String


func _ready() -> void:
	Event.category_selected.connect(_on_Global_category_selected)
	Event.group_selected.connect(_on_Global_group_selected)


func _on_Global_category_selected(category: String) -> void:
	selected_category = category


func _on_Global_group_selected(group: String) -> void:
	selected_group = group
