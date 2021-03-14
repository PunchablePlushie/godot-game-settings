extends Node

enum Type {Slide, List}

export(Type) var type = 0
export(int) var list_range = 10

var buses: Array = []


func _ready() -> void:
	var children: Array = get_children()
	for child in children:
		buses.append(child.name)
