@tool
extends LineEdit

const _TYPE: ggsCore.ItemType = ggsCore.ItemType.GROUP

@export_group("Nodes")
@export var List: ItemList


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	GGS.Event.item_selected.connect(_on_Global_item_selected)


func _create_group(item_name: String) -> void:
	var path: String = GGS.Util.get_item_path(_TYPE, item_name)
	
	DirAccess.make_dir_absolute(path)
	EditorInterface.get_resource_filesystem().scan()


func _set_disabled(disabled: bool) -> void:
	editable = !disabled
	if disabled:
		clear()
		release_focus()


func _on_text_submitted(submitted_text: String) -> void:
	if not GGS.Util.validate_item_name(_TYPE, submitted_text):
		return
	
	clear()
	_create_group(submitted_text)
	List.load_items()


func _on_Global_item_selected(item_type: ggsCore.ItemType, item_name: String) -> void:
	if item_type == ggsCore.ItemType.CATEGORY:
		_set_disabled(item_name.is_empty())
