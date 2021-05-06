tool
extends Button

enum Type {Bool, OptionList, TextField, NumberField, ArrowList, _Slider, Reset = 8}

# Scene Tree
onready var PopMenu: PopupMenu = $PopupMenu

# Resources
onready var BoolComponent: PackedScene = preload("../../components/boolean/ggsBool.tscn")
onready var OptionListComponent: PackedScene = preload("../../components/option_list/ggsOptionList.tscn")
onready var TextFieldComponent: PackedScene = preload("../../components/text_field/ggsTextField.tscn")
onready var NumberFieldComponent: PackedScene = preload("../../components/number_field/ggsNumberField.tscn")
onready var ArrowListComponent: PackedScene = preload("../../components/arrow_list/ggsArrowList.tscn")
onready var SliderComponent: PackedScene = preload("../../components/slider/ggsSlider.tscn")
onready var KeybindKbComponent: PackedScene = preload("../../components/keybind/ggsKeybindKb.tscn")
onready var KeybindGpComponent: PackedScene = preload("../../components/keybind/ggsKeybindGp.tscn")
onready var ResetComponent: PackedScene = preload("../../components/reset/ggsReset.tscn")


# Create the menu itself
func _ready() -> void:
	_populate_menu()


func _populate_menu() -> void:
	# Get and clear the main menu to prevent duplicates
	var MainMenu: PopupMenu = PopMenu
	MainMenu.clear()
	
	# Create Keybind submenu
	var KeybindSub: PopupMenu = PopupMenu.new()
	KeybindSub.set_name("KeybindSub")
	KeybindSub.add_item("Keyboard")
	KeybindSub.add_item("Gamepad")
	KeybindSub.connect("index_pressed", self, "_on_Keybind_item_selected")
	MainMenu.add_child(KeybindSub)
	
	# Create the main menu
	MainMenu.add_item("Boolean")
	MainMenu.add_item("Option List")
	MainMenu.add_item("Text Field")
	MainMenu.add_item("Number Field")
	MainMenu.add_item("Arrow List")
	MainMenu.add_item("Slider")
	MainMenu.add_submenu_item("Keybind", "KeybindSub")
	MainMenu.add_separator()
	MainMenu.add_item("Reset Button")
	MainMenu.connect("index_pressed", self, "_on_Main_item_selected")


# Handle item selection and creation
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
		Type.ArrowList:
			instance = ArrowListComponent.instance()
		Type._Slider:
			instance = SliderComponent.instance()
		Type.Reset:
			instance = ResetComponent.instance()
	
	_add_node(instance)


func _on_Keybind_item_selected(index: int) -> void:
	var instance
	match index:
		0:
			instance = KeybindKbComponent.instance()
		1:
			instance = KeybindGpComponent.instance()
	
	_add_node(instance)


func _add_node(node: Object) -> void:
	var Editor: EditorPlugin = EditorPlugin.new()
	var Interface: EditorInterface = Editor.get_editor_interface()
	var Selection: EditorSelection = Interface.get_selection()
	var selected_nodes: Array = Selection.get_selected_nodes()
	
	# Add the new node as child of the currently selected node
	if selected_nodes != []:
		if selected_nodes.size() == 1:
			selected_nodes[0].add_child(node)
			node.owner = get_tree().edited_scene_root
		else:
			ggsManager.print_err("Add_Node", "Cannot add to multiple nodes. Please select one node only.")
			return
	else:
		ggsManager.print_err("Add_Node", "Cannot add to nothing. Please select a node first.")
		return
	
	# Auto select the new node
	if ggsManager.ggs_data["auto_select_new_nodes"]:
		Selection.clear()
		Selection.add_node(node)
		Interface.inspect_object(node, "setting_index", true)
	
	# Save scene the scene. Newly nodes are not automatically saved in the scene file.
	Interface.save_scene()


# Handle Popupmenu. Couldn't use "MenuButton" because of styling issues.
func _on_AddNode_toggled(button_pressed: bool) -> void:
	if button_pressed:
		var offset: Vector2 = Vector2(0, rect_size.y + 2)
		PopMenu.rect_global_position = rect_global_position + offset
		PopMenu.popup()


func _on_PopupMenu_popup_hide() -> void:
	yield(get_tree().create_timer(0.01), "timeout")
	pressed = false
