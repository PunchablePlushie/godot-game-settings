@tool
extends ScrollContainer

const setting_item_scn: PackedScene = preload("./setting_item/setting_item.tscn")
const setting_group_scn: PackedScene = preload("./setting_group/setting_group.tscn")

var cur_path: String
var btn_group: ButtonGroup = ButtonGroup.new()

@onready var MainCtnr: HFlowContainer = $PanelCtnr/MainCtnr
@onready var GrouplessCtnr: PanelContainer = $PanelCtnr/MainCtnr/GroupLess


func _ready() -> void:
	GGS.active_category_changed.connect(_on_Global_active_category_changed)


func load_list() -> void:
	_clear()
	
	var item_list: Dictionary = _get_item_list()
	var base_dir: String = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
	
	GrouplessCtnr.visible = !item_list["settings"].is_empty()
	for setting in item_list["settings"]:
		if setting.ends_with(".gd"):
			continue
		
		var setting_name: String = setting.get_basename()
		cur_path = base_dir.path_join(setting)
		_add_item(setting_name, GrouplessCtnr, cur_path)
	
	for group in item_list["groups"]:
		cur_path = base_dir.path_join(group)
		var parent: ggsSettingGroup = _add_group(group, cur_path)
		
		var dir: DirAccess = DirAccess.open(cur_path)
		var settings: PackedStringArray = dir.get_files()
		for setting in settings:
			if setting.ends_with(".gd"):
				continue
			
			var setting_name: String = setting.get_basename()
			cur_path = dir.get_current_dir().path_join(setting)
			_add_item(setting_name, parent, cur_path)


func get_selected_groups() -> Array[Node]:
	var result: Array[Node]
	
	var child_count: int = MainCtnr.get_child_count()
	for child_index in range(child_count):
		if child_index == 0:
			continue
		
		var child: ggsSettingGroup = MainCtnr.get_child(child_index)
		var group_is_checked: bool = child.get_checked()
		if group_is_checked:
			result.append(child)
	
	return result


func set_checked_all(checked: bool) -> void:
	var child_count: int = MainCtnr.get_child_count()
	for child_index in range(child_count):
		if child_index == 0:
			continue
		
		MainCtnr.get_child(child_index).set_checked(checked)


func _clear() -> void:
	btn_group = ButtonGroup.new()
	GrouplessCtnr.visible = false
	GGS.active_setting = null
	
	var child_count: int = MainCtnr.get_child_count()
	for child_index in range(child_count):
		if child_index == 0:
			MainCtnr.get_child(child_index).clear()
			continue
		
		MainCtnr.get_child(child_index).queue_free()


func _add_item(setting: String, parent: PanelContainer, path: String) -> void:
	var NewItem: ggsSettingItem = setting_item_scn.instantiate()
	NewItem.text = setting
	NewItem.path = path
	NewItem.btn_group = btn_group
	
	parent.add_item(NewItem)


func _add_group(group: String, path: String) -> ggsSettingGroup:
	var NewGroup: ggsSettingGroup = setting_group_scn.instantiate()
	NewGroup.path = path
	
	MainCtnr.add_child(NewGroup)
	NewGroup.set_group_name(group)
	return NewGroup


func _on_Global_active_category_changed() -> void:
	if GGS.active_category.is_empty():
		_clear()
	else:
		load_list()


### Get Item List

func _get_item_list() -> Dictionary:
	cur_path = ggsUtils.get_plugin_data().dir_settings.path_join(GGS.active_category)
	var dir: DirAccess = DirAccess.open(cur_path)
	var settings: PackedStringArray = dir.get_files()
	var groups: Array = Array(dir.get_directories()).filter(_remove_underscored)
	return {"settings": settings, "groups": groups}


func _remove_underscored(element: String) -> bool:
	return not element.begins_with("_")
