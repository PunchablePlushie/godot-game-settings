@tool
extends Control

const DEFAULT_ICON: Texture2D = preload("res://addons/ggs/assets/components/_default.svg")

@onready var List: ItemList = %ComponentList
@onready var GroupField: LineEdit = %GroupField
@onready var ApplyBtn: Button = %ApplyBtn


func _ready() -> void:
	List.item_activated.connect(_on_List_item_activated)
	GGS.setting_selected.connect(_on_Global_setting_selected)
	
	_load_list()


### List Init

func _load_list() -> void:
	List.clear()
	
	var comp_list: Array[Dictionary] = _get_comp_list()
	for component in comp_list:
		var text: String = component["name"]
		var icon: Texture2D = DEFAULT_ICON if component["icon"].is_empty() else load(component["icon"])
		var meta: String = component["scene"]
		
		var item_index: int = List.add_item(text, icon)
		List.set_item_disabled(item_index, true)
		List.set_item_metadata(item_index, meta)
	
	List.sort_items_by_text()


func _get_comp_list() -> Array[Dictionary]:
	var comp_list: Array[Dictionary]
	
	var path: String
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	var components: PackedStringArray = DirAccess.get_directories_at(data.dir_components)
	for component in components:
		if component.begins_with("_"):
			continue
		
		var info: Dictionary
		path = data.dir_components.path_join(component)
		var info_file: ConfigFile = ConfigFile.new()
		info_file.load(path.path_join("component.cfg"))
		
		info["name"] = info_file.get_value("component", "name", component)
		info["icon"] = info_file.get_value("component", "icon", "")
		info["scene"] = path.path_join("%s.tscn"%component)
		
		comp_list.append(info)
	
	return comp_list


### Component Pre-Instantiation

func _set_items_disabled(disabled: bool) -> void:
	for item_index in range(List.item_count):
		List.set_item_disabled(item_index, disabled)
	
	if disabled:
		List.deselect_all()


func _on_Global_setting_selected(setting: ggsSetting) -> void:
	if setting == null:
		_set_items_disabled(true)
	else:
		_set_items_disabled(false)


### Component Instantiation

func _on_List_item_activated(item_index: int) -> void:
	if List.is_item_disabled(item_index):
		return
	
	var EI: EditorInterface = ggsUtils.get_editor_interface()
	var ES: EditorSelection = EI.get_selection()
	var selected_nodes: Array[Node] = ES.get_selected_nodes()
	
	if selected_nodes.size() != 1:
		printerr("GGS - Instantiate Component: Exactly 1 item in the scene tree must be selected to instantiate components.")
		return
	
	var item_meta: String = List.get_item_metadata(item_index)
	var SelectedNode: Node = selected_nodes[0]
	var ESR: Node = EI.get_edited_scene_root()
	
	var comp_scene: PackedScene = load(item_meta)
	var Component: Control = comp_scene.instantiate()
	Component.setting = GGS.active_setting
	Component.apply_on_change = ApplyBtn.button_pressed
	
	SelectedNode.add_child(Component, true)
	SelectedNode.set_editable_instance(Component, true)
	Component.owner = ESR
	
	if not GroupField.text.strip_edges().is_empty():
		Component.add_to_group(GroupField.text.strip_edges(), true)
	
	EI.save_scene()
