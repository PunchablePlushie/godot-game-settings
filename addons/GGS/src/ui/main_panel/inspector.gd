tool
extends VBoxContainer

var index: int

func clear(label_visible: bool = false) -> void:
	for child in get_children():
		if child.get_index() == 0:
			child.visible = label_visible
		else:
			child.queue_free()
