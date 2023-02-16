@tool
@icon("res://addons/ggs/assets/main_screen_icon.svg")
extends Resource
class_name ggsPluginData

@export_category("GGS Data")
@export var categories: Dictionary
@export var category_order: Array[ggsCategory]

@export_group("Split Offset")
@export var split_offset_0: int = 0


func set_data(data: String, value: Variant) -> void:
	set(data, value)
	_save_self()


### Categories

func add_category(category: ggsCategory) -> void:
	categories[category.name] = category
	category_order.append(category)
	_save_self()


func remove_category(category: ggsCategory) -> void:
	categories.erase(category.name)
	category_order.erase(category)
	_save_self()


func rename_category(prev_name: String, category: ggsCategory) -> void:
	categories.erase(prev_name)
	categories[category.name] = category
	_save_self()


func get_category_name_list() -> PackedStringArray:
	var name_list: PackedStringArray
	for category in categories.values():
		name_list.append(category.name)
	
	return name_list


func update_category_order(new_order: Array[ggsCategory]) -> void:
	category_order.clear()
	category_order = new_order
	_save_self()


### Private
func _save_self() -> void:
	ResourceSaver.save(self, resource_path)
