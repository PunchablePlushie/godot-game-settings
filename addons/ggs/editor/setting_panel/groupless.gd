@tool
extends PanelContainer

@onready var MainCtnr: HFlowContainer = $MainCtnr


func clear() -> void:
	var children: Array[Node] = MainCtnr.get_children()
	for child in children:
		child.queue_free()


func add_item(item: Button) -> void:
	MainCtnr.add_child(item)
