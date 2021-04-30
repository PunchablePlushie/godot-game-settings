tool
extends MenuButton

enum Type {Bool}
var PopupObject: PopupMenu
onready var BoolComponent: PackedScene = preload("../../components/boolean/ggsBool.tscn")


func _ready() -> void:
	PopupObject = get_popup() 
	PopupObject.connect("id_pressed", self, "_on_popup_item_selected")


func _on_popup_item_selected(id: int) -> void:
	var instance
	match id:
		Type.Bool:
			instance = BoolComponent.instance()
	
	_add_node(instance)


func _add_node(node: Object) -> void:
	var Editor: EditorPlugin = EditorPlugin.new()
	var Interface: EditorInterface = Editor.get_editor_interface()
	var Selection: EditorSelection = Interface.get_selection()
	var selected_nodes: Array = Selection.get_selected_nodes()
	
	if selected_nodes != []:
		if selected_nodes.size() == 1:
			selected_nodes[0].add_child(node)
			node.owner = get_tree().edited_scene_root
		else:
			push_error("GGS - AddNode: Cannot add to multiple nodes. Please select one node only.")
			return
	else:
		push_error("GGS - AddNode: Cannot add to nothing. Please select a node first.")
		return
	
	if ggsManager.ggs_data["auto_select_new_nodes"]:
		Selection.clear()
		Selection.add_node(node)
		Interface.inspect_object(node, "setting_index", true)
	Interface.save_scene()
