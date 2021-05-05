extends Button

export(Array, NodePath) var setting_nodes: Array


func _ready() -> void:
	connect("pressed", self, "_on_pressed")


func _on_pressed() -> void:
	for node_path in setting_nodes:
		var node: Object = get_node(node_path)
		node.reset_to_default()
