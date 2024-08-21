@tool
extends Tree

@export var icon: Texture2D

var root = create_item()

func _ready() -> void:
	for i in range(5):
		var item: TreeItem = create_item(root)
		item.set_text(0, "some item name")
		
		for j in range(3):
			var i2: TreeItem = create_item(item)
			i2.set_text(0, "some subitem")
			i2.set_icon(0, icon)
