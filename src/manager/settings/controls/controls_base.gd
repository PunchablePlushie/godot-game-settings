extends Node

var actions: Array


func _ready() -> void:
	var children: Array = get_children()
	for child in children:
		actions.append(child.name)
