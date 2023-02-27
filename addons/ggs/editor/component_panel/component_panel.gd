@tool
extends Control

const DEFAULT_ICON: Texture2D = preload("res://addons/ggs/assets/components/_default.svg")

@onready var List: ItemList = $ComponentList


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
		var meta: Dictionary = {
			"scene": component["scene"],
			"handles": component["handles"],
		}
		
		var item_index: int = List.add_item(text, icon)
		List.set_item_disabled(item_index, true)
		List.set_item_metadata(item_index, meta)


func _get_comp_list() -> Array[Dictionary]:
	var comp_list: Array[Dictionary]
	
	var path: String
	var components: PackedStringArray = DirAccess.get_directories_at(GGS.data.dir_components)
	for component in components:
		var info: Dictionary
		path = GGS.data.dir_components.path_join(component)
		var info_file: ConfigFile = ConfigFile.new()
		info_file.load(path.path_join("component.cfg"))
		
		info["handles"] = info_file.get_value("component", "handles")
		info["name"] = info_file.get_value("component", "name", component)
		info["icon"] = info_file.get_value("component", "icon", "")
		info["scene"] = path.path_join("%s.tscn"%component)
		
		comp_list.append(info)
	
	return comp_list


### Component Pre-Instantiation

func _enable_compatible_items(type: int) -> void:
	for item_index in range(List.item_count):
		var item_type: int = List.get_item_metadata(item_index)["handles"]
		
		var compatible: bool = (item_type == type)
		List.set_item_disabled(item_index, !compatible)


func _disable_all_items() -> void:
	for item_index in range(List.item_count):
		List.set_item_disabled(item_index, true)


func _on_Global_setting_selected(setting: ggsSetting) -> void:
	if setting == null:
		_disable_all_items()
	else:
		_enable_compatible_items(typeof(setting.current))


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
	
	var item_meta: Dictionary = List.get_item_metadata(item_index)
	var SelectedNode: Node = ES.get_selected_nodes()[0]
	var ESR: Node = EI.get_edited_scene_root()
	
	var comp_scene: PackedScene = load(item_meta["scene"])
	var Component: Control = comp_scene.instantiate()
	Component.setting = GGS.active_setting
	
	SelectedNode.add_child(Component, true)
	Component.owner = ESR
	EI.save_scene()
