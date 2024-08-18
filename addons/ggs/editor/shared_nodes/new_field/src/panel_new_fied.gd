@tool
extends LineEdit

@export var _type: ggsCore.ItemType = ggsCore.ItemType.NIL

@export_group("Nodes")
@export var List: ItemList


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	List.items_loaded.connect(_on_List_items_loaded)
	GGS.Event.item_selected.connect(_on_Global_item_selected)
	
	if _type == ggsCore.ItemType.GROUP:
		editable = false


func _create_item(item_name: String) -> void:
	var path: String = GGS.Util.get_item_path(_type, item_name)
	
	DirAccess.make_dir_absolute(path)
	EditorInterface.get_resource_filesystem().scan()


func _set_disabled(disabled: bool) -> void:
	editable = !disabled
	if disabled:
		clear()
		release_focus()


func _on_text_submitted(submitted_text: String) -> void:
	if not GGS.Util.validate_item_name(_type, submitted_text):
		return
	
	clear()
	_create_item(submitted_text)
	List.load_items()


func _on_List_items_loaded() -> void:
	clear()


func _on_Global_item_selected(item_type: ggsCore.ItemType, item_name: String) -> void:
	if item_type != ggsCore.ItemType.CATEGORY:
		return
	
	_set_disabled(item_name.is_empty()) 
