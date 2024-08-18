@tool
extends ConfirmationDialog

@export_group("Title", "title_")
@export var title_category: String
@export var title_group: String
@export var title_setting: String
@export_group("Text", "text_")
@export_multiline var text_category: String
@export_multiline var text_group: String
@export_multiline var text_setting: String

var _item_type: ggsCore.ItemType
var _item_name: String


func _init() -> void:
	visible = false


func _ready() -> void:
	confirmed.connect(_on_confirmed)
	GGS.Event.delete_requested.connect(_on_Global_delete_requested)


func _set_content() -> void:
	match _item_type:
		ggsCore.ItemType.CATEGORY:
			title = title_category
			dialog_text = text_category.format([_item_name])
		ggsCore.ItemType.GROUP:
			title = title_group
			dialog_text = text_group.format([_item_name])
		ggsCore.ItemType.SETTING:
			title = title_setting
			dialog_text = text_setting.format([_item_name])


func _on_Global_delete_requested(item_type: ggsCore.ItemType, item_name: String) -> void:
	_item_type = item_type
	_item_name = item_name
	_set_content()
	
	popup_centered(min_size)
	get_cancel_button().grab_focus()


func _on_confirmed() -> void:
	GGS.Event.delete_confirmed.emit(_item_type, _item_name)
