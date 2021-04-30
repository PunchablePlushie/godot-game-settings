tool
extends MenuButton

enum Type {Bool, OptionList, TextField, NumberField}

# Resources
onready var BoolComponent: PackedScene = preload("../../components/boolean/ggsBool.tscn")
onready var HSliderComponent: PackedScene = preload("../../components/slider/ggsHSlider.tscn")
onready var VSliderComponent: PackedScene = preload("../../components/slider/ggsVSlider.tscn")
onready var OptionListComponent: PackedScene = preload("../../components/option_list/ggsOptionList.tscn")
onready var TextFieldComponent: PackedScene = preload("../../components/text_field/ggsTextField.tscn")
onready var NumberFieldComponent: PackedScene = preload("../../components/number_field/ggsNumberField.tscn")



func _ready() -> void:
	_populate_menu()


func _populate_menu() -> void:
	var MainMenu: PopupMenu = get_popup()
	var SliderSub: PopupMenu = PopupMenu.new()
	SliderSub.set_name("SliderSub")
	SliderSub.add_item("Horizontal")
	SliderSub.add_item("Vertical")
	SliderSub.connect("index_pressed", self, "_on_Slider_item_selected")
	
	MainMenu.add_item("Boolean")
	MainMenu.add_item("Option List")
	MainMenu.add_item("Text Field")
	MainMenu.add_item("Number Field")
	MainMenu.add_child(SliderSub)
	MainMenu.add_submenu_item("Slider", "SliderSub")
	MainMenu.connect("index_pressed", self, "_on_Main_item_selected")


func _on_Main_item_selected(index: int) -> void:
	var instance
	match index:
		Type.Bool:
			instance = BoolComponent.instance()
		Type.OptionList:
			instance = OptionListComponent.instance()
		Type.TextField:
			instance = TextFieldComponent.instance()
		Type.NumberField:
			instance = NumberFieldComponent.instance()
	
	_add_node(instance)


func _on_Slider_item_selected(index: int) -> void:
	var instance
	match index:
		0:
			instance = HSliderComponent.instance()
		1:
			instance = VSliderComponent.instance()
	
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

