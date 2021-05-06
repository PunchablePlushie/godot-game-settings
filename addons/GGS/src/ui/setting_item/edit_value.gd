tool
extends Button

# Scene Tree
onready var Root: HBoxContainer = get_node("../..")

# Resource
onready var KeyScene: PackedScene = preload("../key/uiKey.tscn")
onready var AddKeyScene: PackedScene = preload("../key/uiAddKey.tscn")


func _ready() -> void:
	hint_tooltip = "Edit Value"


func _on_EditValue_pressed() -> void:
	var default = ggsManager.settings_data[str(Root.get_index())]["default"]
	
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
	
	ggsManager.settings_data[str(Root.get_index())]["default"]["value"] = null
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
		
		# Value Field
		KeyInstance.ValueField.text = str(default_value[key])
		
		# Value Type
		var value = default_value[key]
		var type: int
		match typeof(value):
			TYPE_BOOL:
				type = 0
			TYPE_INT:
				type = 1
			TYPE_REAL:
				type = 2
			TYPE_STRING:
				type = 3
		
		KeyInstance.TypeSelectionBtn.selected = type
		KeyInstance.TypeSelectionBtn.text = ""
