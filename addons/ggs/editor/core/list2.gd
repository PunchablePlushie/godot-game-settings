@tool
extends Tree

var root = create_item()

func _ready() -> void:
	for i in range(15):
		var item: TreeItem = create_item(root)
		item.set_text(0, "some item name")
