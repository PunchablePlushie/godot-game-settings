tool
extends Button

# Scene Tree
onready var Root: HBoxContainer = get_node("../..")
onready var Menu: PopupMenu = $PopupMenu

# Resource
onready var KeyScene: PackedScene = preload("../key/uiKey.tscn")
onready var AddKeyScene: PackedScene = preload("../key/uiAddKey.tscn")


func _ready() -> void:
	hint_tooltip = "Edit Value"


func _on_EditValue_pressed() -> void:
	var default = ggsManager.settings_data[str(Root.get_index())]["current"]
	
	# Clear the list and update its index
	Root.MainPanel.Inspector.index = Root.get_index()
	Root.MainPanel.Inspector.clear()

	if default.hash() == {}.hash():
		_create_new_dict()
	else:
		_load_dict(default)
	
	# Create the Add button
	var AddKeyBtn: Button = AddKeyScene.instance()
	AddKeyBtn.index = str(Root.get_index())
	Root.MainPanel.Inspector.add_child(AddKeyBtn)


func _create_new_dict() -> void:
	var KeyInstance: Object = KeyScene.instance()
	KeyInstance.index = str(Root.get_index())
	Root.MainPanel.Inspector.add_child(KeyInstance)
	
	KeyInstance.KeyNameField.text = "value"
	KeyInstance.KeyNameField.editable = false
	KeyInstance.RemoveBtn.disabled = true
	
	ggsManager.settings_data[str(Root.get_index())]["default"]["value"] = null
	ggsManager.settings_data[str(Root.get_index())]["current"]["value"] = null
	ggsManager.save_settings_data()


func _load_dict(default_value: Dictionary) -> void:
	# Create new values based on the saved data
	for key in default_value:
		var KeyInstance: Object = KeyScene.instance()
		KeyInstance.index = str(Root.get_index())
		Root.MainPanel.Inspector.add_child(KeyInstance)
		
		# Key Name
		KeyInstance.KeyNameField.text = key
		KeyInstance.KeyNameField.old_key = key
		if key == "value":
			KeyInstance.KeyNameField.editable = false
			KeyInstance.RemoveBtn.disabled = true
		
		# Value Field
		KeyInstance.ValueField.text = str(default_value[key])
		
		# Value Type
		var value = default_value[key]
		var type: int
		match typeof(value):
			TYPE_BOOL:
				type = 0
			TYPE_REAL:
				type = 1
			TYPE_STRING:
				type = 2
		
		KeyInstance.TypeSelectionBtn.selected = type
		KeyInstance.TypeSelectionBtn.text = ""


# Context Menu
func _on_EditScript_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			_create_popup_menu()


func _create_popup_menu() -> void:
	Menu.clear()
	
	Menu.add_item("Copy Value")
	Menu.add_item("Paste Value")
	
	if ggsManager.value_clipboard.hash() == {}.hash():
		Menu.set_item_disabled(1, true)
		Menu.set_item_tooltip(1, "No value is copied to GGS clipboard")
	
	Menu.rect_global_position = get_global_mouse_position()
	Menu.popup()


func _on_PopupMenu_index_pressed(index: int) -> void:
	match index:
		0:
			ggsManager.value_clipboard = ggsManager.settings_data[str(Root.get_index())]["default"]
			ggsManager.print_notif("%02d"%[Root.get_index()], "Value copied to GGS clipboard.")
		1:
			ggsManager.settings_data[str(Root.get_index())]["default"] = ggsManager.value_clipboard.duplicate()
			_on_EditValue_pressed()


func _on_EditValue_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			_create_popup_menu()
