extends Button

export(Array, NodePath) var setting_nodes: Array


func _ready() -> void:
	connect("pressed", self, "_on_pressed")
	connect("mouse_entered", self, "_on_mouse_entered")


func _on_pressed() -> void:
	for node_path in setting_nodes:
		var node: Object = get_node(node_path)
		node.reset_to_default()


# Handle mouse focus
func _on_mouse_entered() -> void:
	grab_focus()
