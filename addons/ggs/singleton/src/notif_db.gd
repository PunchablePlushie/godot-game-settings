@tool
extends Node

@export_group("Item Name", "item_name_")
@export var item_name_invalid: ggsNotifContent
@export var item_name_exists: ggsNotifContent

@export_group("Preferences", "pref_")
@export var pref_err_save: ggsNotifContent
@export var pref_err_get_config: ggsNotifContent
@export var pref_err_set_config: ggsNotifContent


func show_err(content: ggsNotifContent, args: Array) -> void:
	var title: String = content.title
	var message: String = content.text.format(args)
	printerr("GGS: %s - %s"%[title, message])
