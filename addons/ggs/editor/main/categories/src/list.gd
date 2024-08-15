@tool
extends ItemList

@onready var FSD: FileSystemDock = EditorInterface.get_file_system_dock()
@export var ReloadAnimation: AnimationPlayer


func _ready() -> void:
	#item_activated.connect(_on_item_activated)
	#item_selected.connect(_on_item_selected)
	
	load_list()


func load_list() -> void:
	clear()
	
	var categories: PackedStringArray = _load_from_filesystem()
	for category in categories:
		add_item(category)
	
	GGS.State.selected_category = ""
	ReloadAnimation.play("flash", -1, 7.0);


func _on_item_selected(item_index: int) -> void:
	var item_text: String = get_item_text(item_index)
	GGS.active_category = item_text


func _on_item_activated(item_index: int) -> void:
	var item_text: String = get_item_text(item_index)
	var base_path: String = ggsPluginPref.new().get_config("dir_settings")
	var path: String = base_path.path_join(item_text)
	EditorInterface.select_file(path)


# Load Categories #
func _load_from_filesystem() -> PackedStringArray:
	var dir_settings: String = ggsPluginPref.new().get_config("dir_settings")
	var dir: DirAccess = DirAccess.open(dir_settings)
	var list: Array = Array(dir.get_directories()).filter(_remove_underscored)
	return PackedStringArray(list)


func _remove_underscored(element: String) -> bool:
	return not element.begins_with("_")
