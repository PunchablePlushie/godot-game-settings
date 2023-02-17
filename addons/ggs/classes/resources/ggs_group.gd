@tool
@icon("res://addons/ggs/assets/classes/group.svg")
extends ggsCatItem
class_name ggsGroup

const PROP_IGNORE_LIST: PackedStringArray = [
	"name",
	"icon",
	"category",
	"settings",
	"item_order",
	"key",
	"group",
	"current",
	"default",
	]


@export_category("Setting Group")
@export var name: String
@export_group("Group Internals")
@export var settings: Dictionary
@export var item_order: Array[ggsSetting]


#:: Add this to ggsGroup
func _init() -> void:
	for property in get_property_list():
		if not _property_is_exported(property["usage"]):
			continue
		
		if PROP_IGNORE_LIST.has(property["name"]):
			continue
		
		prints(property["name"])

#:: Add this to utils
func _property_is_exported(property_usage: int) -> bool:
	return property_usage == (PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_DEFAULT)
