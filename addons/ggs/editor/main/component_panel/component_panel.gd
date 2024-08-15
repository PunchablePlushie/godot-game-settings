@tool
extends Control

@onready var GroupField: LineEdit = %GroupField
@onready var ASI: LineEdit = %ActiveSettingIndicator
@onready var CASBtn: Button = %ClearActiveSettingBtn
@onready var List: ItemList = %ComponentList


func _ready() -> void:
	List.item_activated.connect(_on_List_item_activated)
	
	CASBtn.pressed.connect(_on_CASBtn_pressed)
	GGS.active_setting_changed.connect(_on_Global_active_setting_changed)
	
	_load_list()


func _on_CASBtn_pressed() -> void:
	GGS.active_setting = null


func _on_Global_active_setting_changed() -> void:
	ASI.text = GGS.active_setting.name if GGS.active_setting else ""


### List Init

func _load_list() -> void:
	List.clear()
	
	var comp_list: Array[Dictionary] = _get_comp_list()
	for component in comp_list:
		var text: String = component["name"]
		var meta: String = component["scene"]
		
		var item_index: int = List.add_item(text)
		List.set_item_metadata(item_index, meta)
	
	List.sort_items_by_text()


func _get_comp_list() -> Array[Dictionary]:
	var comp_list: Array[Dictionary]
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var components: PackedStringArray = DirAccess.get_directories_at(data.dir_components)
	for component in components:
		if component.begins_with("_"):
			continue
		
		var info: Dictionary
		var path: String = data.dir_components.path_join(component)
		
		info["name"] = component.capitalize()
		info["scene"] = path.path_join("%s.tscn"%component)
		
		comp_list.append(info)
	
	return comp_list


### Component Instantiation

func _on_List_item_activated(item_index: int) -> void:
	var EI: EditorInterface = ggsUtils.get_editor_interface()
	var ES: EditorSelection = EI.get_selection()
	var selected_nodes: Array[Node] = ES.get_selected_nodes()
	
	if selected_nodes.size() != 1:
		printerr("GGS - Instantiate Component: Exactly one item in the scene tree must be selected to instantiate a component.")
		return
	
	var item_meta: String = List.get_item_metadata(item_index)
	var SelectedNode: Node = selected_nodes[0]
	var ESR: Node = EI.get_edited_scene_root()
	
	var comp_scene: PackedScene = load(item_meta)
	var Component: Control = comp_scene.instantiate()
	Component.setting = GGS.active_setting
	Component.apply_on_change = ggsUtils.get_plugin_data().apply_on_changed_all
	Component.grab_focus_on_mouse_over = ggsUtils.get_plugin_data().grab_focus_on_mouse_over_all
	
	SelectedNode.add_child(Component, true)
	SelectedNode.set_editable_instance(Component, true)
	Component.owner = ESR
	
	if not GroupField.text.strip_edges().is_empty():
		Component.add_to_group(GroupField.text.strip_edges(), true)
	
	EI.save_scene()
