@tool
extends LineEdit

const _TYPE: ggsCore.ItemType = ggsCore.ItemType.CATEGORY

@export_group("Nodes")
@export var List: ItemList


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)


func _create_category(item_name: String) -> void:
	var path: String = GGS.Util.get_item_path(_TYPE, item_name)
	
	DirAccess.make_dir_absolute(path)
	EditorInterface.get_resource_filesystem().scan()


func _on_text_submitted(submitted_text: String) -> void:
	if not GGS.Util.validate_item_name(_TYPE, submitted_text):
		return
	
	clear()
	_create_category(submitted_text)
	List.load_items()
