@tool
extends Node

@export var section: String
@export var key: String

@onready var managed_node: Control = get_parent()


func _ready() -> void:
	GGS.Event.ui_vis_changed.connect(_on_Global_ui_vis_changed)
	managed_node.visible = GGS.Pref.res.ui_vis[section][key]


func _reset_managed_node() -> void:
	managed_node.release_focus()
	
	if managed_node is LineEdit:
		managed_node.clear()


func _on_Global_ui_vis_changed(pref_section: String, element: String, vis: bool) -> void:
	if pref_section == section  and element == key:
		managed_node.visible = vis
	
	if not managed_node.visible:
		_reset_managed_node()
