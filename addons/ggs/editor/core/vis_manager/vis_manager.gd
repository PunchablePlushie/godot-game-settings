@tool
extends Node

@export var pref_cat: String
@export var pref_id: String

var config: String

@onready var managed_node: Control = get_parent()


func _ready() -> void:
	config = "SHOW_UI_%s_%s"%[pref_cat, pref_id]
	
	GGS.Event.ui_vis_changed.connect(_on_Global_ui_vis_changed)
	managed_node.visible = ggsPluginPref.new().get_config(config)


func _reset_managed_node() -> void:
	managed_node.release_focus()
	
	if managed_node is LineEdit:
		managed_node.clear()


func _on_Global_ui_vis_changed(pref_category: String, ui: String, vis: bool) -> void:
	if pref_category == pref_cat  and ui == pref_id:
		managed_node.visible = vis
	
	if not managed_node.visible:
		_reset_managed_node()
