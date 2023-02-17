@tool
extends PanelContainer

enum TargetSignal {CATEGORY, ITEM}

@export_node_path("Control") var target_node: NodePath
@export var target_signal: TargetSignal

@onready var TargetNode: Control = get_node(target_node)


func _ready() -> void:
	visible = true
	TargetNode.hide()
	
	if target_signal == TargetSignal.CATEGORY:
		GGS.category_selected.connect(_on_target_signal_emitted)


func _on_target_signal_emitted(object: Resource) -> void:
	if object != null:
		hide()
		TargetNode.visible = true
	else:
		visible = true
		TargetNode.hide()
